Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'

      resources :transactions, only: [] do
        post ':wallet_id/transfer', to: 'transactions#transfer', on: :collection
        post ':wallet_id/withdraw', to: 'transactions#withdraw', on: :collection
        post ':wallet_id/topup', to: 'transactions#topup', on: :collection
      end
    end
  end
end
