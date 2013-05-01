Nameface::Application.routes.draw do

resources :users, :except => [:destroy]
resource :session, :only => [:new, :create, :destroy]
# resources :events, :except => [:new, :create, :edit, :update, :destroy]

resources :events, :only => [:index, :show] do 
  collection do 
    get 'add_event_to_user'
    get 'remove_event_from_user'
  end 
end 

# resource :admin do
# 	resource :events, only: [:new, :create, :update, :destroy]
# end

scope "/admin" do
	resources :events, only: [:new, :create, :edit, :update, :destroy] 
end

root :to => 'pages#index'
get '/auth/:provider/callback', to: 'sessions#create'

end
