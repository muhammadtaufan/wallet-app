Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'

      namespace :transactions do
        post ':wallet_id/transfer', action: 'transfer'
        post ':wallet_id/withdraw', action: 'withdraw'
        post ':wallet_id/topup', action: 'topup'
      end

      namespace :stocks do
        get 'price', action: 'price'
        get 'prices', action: 'prices'
        get 'price_all', action: 'price_all'
      end
    end
  end
end
