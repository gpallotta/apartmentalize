Apartmentalize::Application.routes.draw do

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
  resources :managers, :except => [:index]
  resources :comments, :only => [:create, :edit, :update, :destroy]

  # root :to => 'front_page#home', :as => 'home_page'
  # match "/welcome" => 'front_page#welcome', :as => 'welcome_page'
  root :to => 'front_page#welcome', :as => 'welcome_page'
  match "/home" => 'front_page#home', :as => 'user_root'
  match "/about" => 'front_page#about', :as => 'about_page'
  match "/help" => 'front_page#help', :as => 'help_page'

end
