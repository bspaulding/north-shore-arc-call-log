ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'login'
  
  map.resources :database_updates
  map.resources :advanced_searches
  map.resources :houses
  map.resources :individuals
  map.resources :people
  
  map.connect '/people/search', :controller => 'people', :action => 'search'
  map.connect '/people/advanced_search', :controller => 'people', :action => 'advanced_search'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
