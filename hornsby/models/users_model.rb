require 'digest/sha1'
class Hornsby::Design::Example
  def shash(*args)
    Digest::SHA1.hexdigest(*args)
  end
end
  

model :users do
  rounding_rule :string
  
  example :lachie do |u|
    u.name = "Lachlan Cox"
    
    u.email = 'lachie@gmail.com'
    u.irc_nick = 'lachie'
    
    u.aliases = 'Brother RSpec,Lachie'
    u.blurb = "He's just this guy, you know?"
    
    u.location = "Normanhurst"
    
    u.mugshot = link(:lachie_mugshot)
    
    u.password_hash = shash("foo"+shash("salty"))
    u.password_salt = shash("salty")
    
    u.flickr_uid = 'lachie'
    u.delicious_uid = 'lachie'
    
    u.created_at = Time.now.to_i
    u.updated_at = 0
  end
  
  example :bob do |u|
    u.name = "Bob Smith"
        
    u.password_hash = shash("bar"+shash("salty2"))
    u.password_salt = shash("salty2")
    
    u.created_at = 2.days.ago.to_i
    u.updated_at = 1.days.ago.to_i
  end
end


model :feeds do
  example :lachie_tumble do |f|
    f.user = link(:lachie)
    f.url = 'http://lachie.info/entries/rss'
    f.aggregate = false
  end
  
  example :lachie_blog do |f|
    f.user = link(:lachie)
    f.url = 'http://blog.lachie.info/feed/atom.xml'
    f.aggregate = true
  end
end

model :links do
  example :lachie_x do |l|
    l.user = link(:lachie)
    l.url = 'http://slashdot.org'
    l.title = 'Slashdot'
    l.notes = "Its slashdot, duh"
  end
end

model :mugshots do
  generate :except => %w{model}
  
  column_hint :parent_id, :integer
  column_hint :filename    , :string
  column_hint :thumbnail   , :string
  column_hint :content_type, :string, :null => false
  column_hint :size, :integer, :null => false
  column_hint :width, :integer
  column_hint :height, :integer
  
  example :lachie_mugshot do |m|
    m.filename = "lachie1.png"
    m.content_type = "image/png"
    m.size = 100
  end
end