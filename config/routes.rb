Rails.application.routes.draw do
  namespace "api" do
    namespace "v0" do
      resources :groups, only: [:index, :create, :show]
      resources :users, only: [:create]
      delete "/sessions/logout", to: "sessions#logout"
      resources :sessions, only: [:index, :create]
      resources :students, only: [:create, :index, :show]
      get "/class_availabilities/search", to: "class_availabilities#search"
      resources :class_availabilities, only: [:update, :create]
      resources :courses, only: [:index, :create]
      get "progresses/search", to: "progresses#search"
      patch "progresses/bulk_update", to: "progresses#bulk_update"
      post "progresses/bulk_create", to: "progresses#bulk_create"
    end
  end
end
