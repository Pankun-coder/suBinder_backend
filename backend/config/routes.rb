Rails.application.routes.draw do
  namespace "api" do
    namespace "v0" do
      resources :groups
    end
  end
end
