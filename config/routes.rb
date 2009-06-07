ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |a|
    a.connect '', :controller => 'application'
    a.resources(:groups) do |group|
      group.resources(:meetings) do |meeting|
        meeting.resources(:presos)
      end
    end
  end
  
  
  map.resources :facet_kinds
  
  map.resources :meetings
  map.resources :analogue_blogs, :controller => :meetings
  map.resources :facets
  map.resources :repos

  map.resources :users,
    :member => {
      :link_affiliation => :post
    },
    :collection => {
      :pinboard    => :get,
      :thankyous   => :get,
      :beerating   => :get,
      :chatter     => :get,
      :all_chatter => :get,
      :beergraph   => :get,
      :search      => :get
    }
  
  map.resources(:mugshots, :collection => { :update_all_thumbnails => :get })
    
  map.resources :thankyous,
    :collection => { :beergraph => :get }

  map.resources :presentations
  
  map.resources :groups do |group|
    group.resources(:meetings) do |meeting|
      meeting.resources(:presos) do |preso|
        preso.resources(:comments)
        preso.resources(:preso_ratings)
      end
    end
  end


  map.resources :user_sessions
  
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login  'login', :controller => 'user_sessions', :action => 'new'
  map.signup 'signup', :controller => 'users', :action => 'new'

  # map.reset_password 'accounts/reset_password', :controller => 'accounts', :action => 'reset_password'
  
  
  map.feed "/index", :controller => 'front'
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.root :controller => "front"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
