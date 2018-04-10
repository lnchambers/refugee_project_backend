Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'results', to: 'results#show'
    end
  end
end
