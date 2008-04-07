# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  
  class FacebookFormBuilder < ActionView::Helpers::FormBuilder
    def wrap(name,content,options={})
      mand = options.delete(:mandatory) ? '<strong class="mand">*</strong>' : ''
      extras = options.delete(:extras)
      byline = options[:byline].blank? ? '' : "<br/><span class='byline'>#{options.delete(:byline)}</span>"
      
      @template.content_tag('p',"#{name.to_s.humanize}#{mand} #{extras}<br/>#{content}#{byline}")
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
      @template.content_tag('p', @template.submit_tag(@object.new_record? ? oncreate : onupdate))
    end
  end

  def facebook_form_for(object, options={}, &proc)
    form_for(object, options.merge(:builder => FacebookFormBuilder), &proc)
  end
  
  def authorised?
    @controller.authorized?
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
end
