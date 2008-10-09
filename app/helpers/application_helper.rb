# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  
  class FacebookFormBuilder < ActionView::Helpers::FormBuilder
    def wrap(title,content,options={})
      mand = options.delete(:mandatory) ? '<strong class="mand">*</strong>' : ''
      extras = options.delete(:extras)
      byline = options[:byline].blank? ? '' : "<br/><span class='byline'>#{options.delete(:byline)}</span>"
      
      title = options[:title] || title.to_s.titleize
      
      @template.content_tag('div',"<label>#{title} #{mand}</label> #{extras}<br/>#{content}#{byline}")
    end
    
    # dry!
    def text_field(name,options={})
      wrap(name,super,options)
    end
    
    def text_area(name,options={})
      wrap(name,super,options)
    end
    
    def password_field(name,options={})
      wrap(name,super,options)
    end
    
    def file_field(name,options={})
      wrap(name,super,options)
    end
    
    def submit(oncreate='create',onupdate='update')
      @template.content_tag('div', @template.submit_tag(@object.new_record? ? oncreate : onupdate))
    end
  end

  def facebook_form_for(object, options={}, &proc)
    form_for(object, options.merge(:builder => FacebookFormBuilder), &proc)
  end
  
  def authorised?
    @controller.send :authorized?
  end
  
  def logged_in_but_other_user?
    @controller.logged_in_but_other_user?
  end
  
  def redirect_to_current_user
    redirect_to (logged_in? ? user_path(current_user) : users_path)
  end
  
  SCHEME_RE = /^\w+:\/\//
  
  def clean_link(link,if_blank="")
    return if_blank if link.blank?
    link[SCHEME_RE] ? link : "http://#{link}"
  end
  
  def hsv2rgb(*hsv)
    h,s,v = *hsv
    m,n,f =nil,nil,nil
    
    h = h / 60.0

    i = h.floor
    f = h - i

    f = 1 - f if i.even?

    m = v * (1 - s)
    n = v * (1 - s * f)
    

    case i
      when 0,6 then [v,n,m]
      when 1 then [n, v, m]
      when 2 then [m, v, n]
      when 3 then [m, n, v]
      when 4 then [n, m, v]
      when 5 then [v, m, n]
    end
  end

  def rgb2hex(*rgb)
    "#%02x%02x%02x" % rgb.map {|e| (e * 255).to_i}
  end
  
  def stars(rating)
    stars = Float(rating).round
    no_stars = 5-stars
    
    text = ""
    stars.times { text << "<div class='star star_on'><a></a></div>"}
    no_stars.times { text << "<div class='star'><a></a></div>"}
    
    text
  end
  
  def javascripts(*sources)
    options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }

    # Start the list
    javascripts = []

    # Include extra javascripts
    if options["include"]
      options["include"].each do |javascript|
        javascripts << javascript
      end
    end

    # Controller/action javascripts
    controller_name = controller.class.to_s.underscore.sub(/_controller$/,'')
    javascripts << "#{controller_name}"
    javascripts << "#{controller_name}-#{controller.action_name}"

    # Link to all user javascripts
    javascripts.collect! do |name|
      name = "auto/#{name}"
      if File.exist?("#{RAILS_ROOT}/public/javascripts/#{name}.js")
        javascript_include_tag(name)
      end
    end

    # Link to applicaton.js and defaults (if requested)
    javascripts.compact.join("\n").to_s
  end
  
  def formatting_help
    "(use textile + <a href='http://github.com/xaviershay/lesstile'>lesstile</a> with <a href='http://pygments.org/languages/'>pygments</a>)"
  end
end
