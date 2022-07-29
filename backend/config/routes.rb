Rails.application.routes.draw do

  namespace "api" do
    namespace "v0" do
      resources :groups
      resources :users
      delete "/sessions/logout", to: "sessions#logout"
      resources :sessions
      get "/students/search", to: "students#search"
      resources :students
      get "/class_availabilities/search", to: "class_availabilities#search"
      resources :class_availabilities
      resources :courses
      get "progresses/search", to: "progresses#search"
      patch "progresses/bulk_update", to: "progresses#bulk_update"
      post "progresses/bulk_create", to: "progresses#bulk_create"
      resources :progresses
    end
  end
end
