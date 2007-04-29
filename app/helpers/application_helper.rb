# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  
  class FacebookFormBuilder < ActionView::Helpers::FormBuilder
    def wrap(name,content,options={})
      mand = options.delete(:mandatory) ? '<strong class="mand">*</strong>' : ''
      extras = options.delete(:extras)
      @template.content_tag('p',"#{name.to_s.humanize}#{mand} #{extras}<br/>#{content}")
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
  
  def redirect_to_current_user
    redirect_to (logged_in? ? user_path(current_user) : users_path)
  end
  
  SCHEME_RE = /^\w+:\/\//
  
  def clean_link(link,if_blank="")
    return if_blank if link.blank?
    link[SCHEME_RE] ? link : "http://#{link}"
  end
end
