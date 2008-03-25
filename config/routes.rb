ActionController::Routing::Routes.draw do |map|
  map.resources :facet_kinds
  
  map.resources :facets

  map.resources :users,
    :member => {
      :link_affiliation => :post
    },
    :collection => {
      :pinboard  => :get,
      :thankyous => :get,
      :beerating => :get,
      :chatter   => :get
    }
  
  map.resources :mugshots, 
    :collection => { :update_all_thumbnails => :get }
    
  map.resources :thankyous,
    :collection => { :beergraph => :get }
  
  map.resources :meetings
  
  map.resources :presentations
  
  map.resources :groups
  
  map.logout 'accounts/logout', :controller => 'accounts', :action => 'logout'
  map.login  'accounts/login', :controller => 'accounts', :action => 'login'
  map.signup 'accounts/signup', :controller => 'accounts', :action => 'signup'
  map.reset_password 'accounts/reset_password', :controller => 'accounts', :action => 'reset_password'
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "users"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
