ActionController::Routing::Routes.draw do |map|
  map.resources :advanced_searches

  map.root :controller => 'login'
  
  map.connect '/people/search', :controller => 'people', :action => 'search'
  map.connect '/people/advanced_search', :controller => 'people', :action => 'advanced_search'
  
  # Temporary Routes
  map.connect '/houses', :controller => 'houses', :action => 'index'
  map.connect '/houses/show/:id', :controller => 'houses', :action => 'show'
  
  map.resources :people
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
