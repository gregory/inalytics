Inalytics::Application.routes.draw do
  root to: 'dashboard#server_request_log'
  resources :server_request_logs, only: [] do
    collection do
      get :top_urls
    end
  end
end
