require 'digest/sha1'

module ThankyouExt
  def last_month
    # find(:all, :conditions => 'date(updated_at) > cur_date()-1')
  end
end

class User < ActiveRecord::Base
	belongs_to :mugshot
	has_many :facets
  
  has_many :affiliations
  has_many :groups, :through => :affiliations
  
  has_many :thankyous_by, :class_name => 'Thankyou', :foreign_key => 'from_id', :order => 'created_at desc'
  has_many :thankyous_to, :class_name => 'Thankyou', :foreign_key => 'to_id'  , :order => 'created_at desc'
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false
  before_save :encrypt_password
  

  def self.beeratings(to=:to)
    
    user_id = to == :to ? 'to_id' : 'from_id'
    
    rows = connection.select_all(%{SELECT #{user_id},count(*) as score
      FROM thankyous t
      where datediff(now(),created_at) <= 14
      group by #{user_id}
      having count(*) > 0
      order by 2 desc})
      
    return [] if rows.blank?

    top_score = rows.first['score'].to_f

    rows.collect do |row|
      [User.find(row[user_id]), (row['score'].to_i / top_score) * 5.0]
    end
  end
  
  def beerating
    beeratings.detect {|r| r[0].id == self.id}
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find_by_email(email) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  
  
  ######################
  # facebook stuff
  
  def nick
    @nick ||= [irc_nick, name, email.sub('@','(a)')].reject {|s| s.blank?}.first || "no username!"
  end
  
  def to_param
    irc_nick.blank? ? self.id.to_s : "#{id}-#{irc_nick}"
  end
  
  SCHEME_RE = /^\w+:\/\//
  
  def site_url
    site = self['site_url']
    site[SCHEME_RE] ? site : "http://#{site}" unless site.blank?
  end
  
  def feed_description
    if updated_at == created_at
      "#{nick} created a profile."
    else
      "#{nick} updated their profile."
    end
  end
  
  def thumbnail_public_path
    self.mugshot ? self.mugshot.public_filename(:thumb) : '/images/no-mugshot.png'
  end
  
  def for_glass
    [id,nick,thumbnail_public_path]
  end
  
  
  def all_affiliations
    my_groups = self.groups
    stub_affiliations = Affiliation.stub_all_possible_affiliations.reject do |a|
      my_groups.include? a.group
    end
    
    [self.affiliations, stub_affiliations].flatten
  end
  
  def visitor?
    !regular?
  end
  
  def ensure_affiliation(params={})
    return nil unless params[:group_id]
    
    affiliation = affiliations.find_by_group_id(params[:group_id])
    linked = params.delete(:linked)
    linked = !(linked == 'false' || linked.blank?)

    if affiliation
      
      unless linked
        logger.debug("destroying!")
        affiliation.destroy
        affiliation = Affiliation.new(params)
      else
        affiliation.presenter = params[:presenter]
        affiliation.regular   = params[:regular]
      end
    
    else
      affiliation = Affiliation.new(params.merge(:user => self))
    end
    
    affiliation.save! if linked   
    affiliation
  end
  
  def self.regenerate_all_thumbnails
    User.find(:all).each {|u| u.mugshot.regenerate_thumbnails if u.mugshot rescue nil }
  end
  
  def self.find_by_stripped_irc_nick(nick)    
    common_suffixes = [/_away/, /_working/, /_lunch/]
    common_suffixes.each {|suffix| nick.gsub!(suffix, "")}
    find(:first,:conditions => ["lower(trim(both '_' from irc_nick)) = lower(trim(both '_' from ?)) or lower(trim(both '_' from alternate_irc_nick)) = lower(trim(both '_' from ?))", nick, nick])
  end
  
  def feed_sort_date
    updated_at
  end

  def to_json(*options)
    public_attributes.to_json
  end
  
  def to_xml(options={})
    options[:root] ||= :user
    public_attributes.to_xml(options)
  end
  
  def self.find_for_pinboard
    find(:all,:order => 'mugshots.id DESC,users.id DESC', :include => :mugshot)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def public_attributes
      {
        :id => self.id,
        :name => self.name,
        :site_url => self.site_url,
        :site_name => self.site_name,
        :irc_nick => self.irc_nick,
        :alternate_irc_nick => self.alternate_irc_nick,
        :location => self.location,
        :created_at => self.created_at,
        :updated_at => self.updated_at,
        :mugshot => self.mugshot && {
          :id => self.mugshot.id,
          :full_filename => self.mugshot.filename,
          :thumbnail_filename => self.mugshot.thumbnail_name_for(:thumb)
        },
        :thankyous_count => {
         :by => self.thankyous_by.count,
         :to => self.thankyous_to.count
        }
      }
    end
end
