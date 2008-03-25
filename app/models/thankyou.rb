class Thankyou < ActiveRecord::Base
  belongs_to :from, :class_name => 'User', :foreign_key => 'from_id'
  belongs_to :to  , :class_name => 'User', :foreign_key => 'to_id'  
  
  validates_presence_of :reason, :from_id, :to_id
  
  def feed_title
    "#{from.nick} owed #{to.nick} a beer"
  end
  
  def feed_description
    "#{from.nick} owed #{to.nick} a beer for #{reason}"
  end
  
  def feed_sort_date
    created_at
  end
  
  def to_xml(*options)
    public_attributes.to_xml(*options)
  end
  
  def to_json(*options)
    public_attributes.to_json
  end
  
  extend Graphs
  
  def self.to_dot(*args)
    dottify "thankyous" do |output|
    
      thanks        = Hash.auto { Hash.auto { 0 } }
      to_totals     = Hash.auto { 0 }
      from_totals   = Hash.auto { 0 }
    
      self.find(*args).each do |thankyou|
        from = thankyou.from.irc_nick or next
        to   = thankyou.to.irc_nick or next
      
        if from.blank?
          puts "from was blank #{thankyou.inspect}"
          next
        end
        if to.blank?
          puts "to was blank #{thankyou.inspect}"
          next
        end
      
        from.gsub!(/\W/,'')
        to.gsub!(/\W/,'')
      
        thanks[from][to]  += 1
        to_totals[to]     += 1
        from_totals[from] += 1
      end
    
      max_count = to_totals.values.max.to_f
      max_size = 1.0
      min_size = 0.25
      delta_size = max_size - min_size
    
      (to_totals.keys | from_totals.keys).each do |name|
        tos   = to_totals[name]   || 0
        froms = from_totals[name] || 0
        size  = (tos / max_count) * delta_size + min_size
      
        output << "\t#{name} [width=#{size},label=\"\\N (#{tos}/#{froms})\"];\n"
      end
    
      thanks.each do |(from,tos)|
        tos.each do |(to,count)|
          output << "\t#{from} -> #{to} [weight=#{count}];\n"
        end
      end
    end
  end
  
  def self.draw_graph(*args)
    dot = RAILS_ROOT+"/tmp/thankyous.dot"
    png = File.join(RAILS_ROOT,'public','images','beergraph.png')
    
    open(dot,'w') do |f|
      f << to_dot(*args)
    end
    
    system "neato -o #{png} -Tpng #{dot} &"
  end
  
  def self.find_thanks_for_graph(*args)
    thanks_to   = Hash.auto {0}
    thanks_from = Hash.auto {0}
    thanks      = Hash.auto {Hash.auto {0}}
    
    find(*args).each do |thankyou|
      from = thankyou.from.irc_nick or next
      to   = thankyou.to.irc_nick or next
    
      if from.blank?
        puts "from was blank #{thankyou.inspect}"
        next
      end
      if to.blank?
        puts "to was blank #{thankyou.inspect}"
        next
      end
      
      thanks_to[to]     += 1
      thanks_from[from] += 1
      thanks[to][from]  += 1
    end
    
    names = (thanks_to.keys|thanks_from.keys).sort_by {|name| thanks_to[name] - thanks_from[name]}
    
    nn = []
    names.each_with_index do |name,i|
      if i % 2 == 0
        nn.push name
      else
        nn.unshift name
      end
    end
    
    [nn,thanks,thanks_to,thanks_from]
  end
  
  protected
    def public_attributes
      {
        :id => self.id,
        :from_id => self.from_id,
        :to_id => self.to_id
      }
    end
end
