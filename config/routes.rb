ApartmentV2::Application.routes.draw do

  resources :activities

  devise_for :users, :controllers => {:registrations => "registrations",
        :invitations => 'invitations' }

  resources :groups do
    post :lookup, :on => :collection
  end

  resources :chores, :except => [:new, :show]

  resources :claims do
    put :mark_as_paid, :on => :member
  end
  resources :users, :only => [:show]
  resources :managers, :except => [:index, :show]
  resources :comments, :only => [:create, :edit, :update, :destroy]

  root :to => 'front_page#home', :as => 'home_page'
  match "/welcome" => 'front_page#welcome', :as => 'welcome_page'
  match "/about" => 'front_page#about', :as => 'about_page'

end
