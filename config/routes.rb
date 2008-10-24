ActionController::Routing::Routes.draw do |map|
  map.resources :workers

  map.root :controller => 'home'
  
  map.resources :workers
  map.resources :managers
  map.resources :directors
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
