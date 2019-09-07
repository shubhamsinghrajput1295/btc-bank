Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations'}
	devise_scope :user do
	  root to: "users/sessions#new"
	end
	resources :accounts, only: [:index]

	get '/balance', to: "accounts#get_balance", as: :get_balance
	get '/deposit_money', to: "accounts#deposit_money", as: :deposit_money
	post '/save_deposit_money', to: "accounts#save_deposit_money", as: :save_deposit_money
	get '/withdraw_money', to: "accounts#withdraw_money", as: :withdraw_money
	post '/debit_money', to: "accounts#debit_money", as: :debit_money
	get '/transfer_money', to: "accounts#transfer_money", as: :transfer_money
	post '/send_transfer_money', to: "accounts#send_transfer_money", as: :send_transfer_money
	get '/passbook', to: "accounts#passbook", as: :passbook
end
