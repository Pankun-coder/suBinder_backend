Rails.application.routes.draw do

  namespace "api" do
    namespace "v0" do
      resources :groups
      resources :users
      resources :sessions
      get "/students/search", to: "students#search"
    end
  end
end
