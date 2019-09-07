class AccountsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_account_and_balance
	before_action :set_transfer_user, only: [:send_transfer_money]

	def index	
	end

	def get_balance
	end

	def deposit_money
	end

	def save_deposit_money
		ActiveRecord::Base.transaction do 
			@account.current_balance = @balance.to_f + params[:deposit_money].to_f
			if @account.save
				Transaction.entry(@account, "credit", params[:deposit_money])
				redirect_to get_balance_path, notice: "Money has been desposited successfully."
			else
				render :deposit_money, alert: @account.errors.full_message
			end
		end	
	end

	def withdraw_money
	end

	def debit_money
		ActiveRecord::Base.transaction do
			amount  = @account.check_amount(@balance, params[:withdraw_money])
			if amount  
				@account.current_balance = @balance.to_f - params[:withdraw_money].to_f
				if @account.save
					Transaction.entry(@account, "debit", params[:withdraw_money])
					redirect_to get_balance_path, notice: "Money has been withdraw successfully."
				else
					render :withdraw_money, alert: @account.errors.full_message
				end
			else
				redirect_to get_balance_path, alert: "Insufficient balance in your account."
			end
		end		
	end

	def transfer_money
		@users = User.where.not(id: current_user.try(:id))
	end

	def send_transfer_money
		ActiveRecord::Base.transaction do
			amount = @account.check_amount(@balance, params[:amount])
			if amount 
				begin
					@account.current_balance = @balance.to_f - params[:amount].to_f
					@account.save
					Transaction.entry(@account, "debit", params[:amount], params[:comment])
					transfer_user_account = @transfer_to_user.account
					transfer_user_account.current_balance = transfer_user_account.current_balance.to_f + params[:amount].to_f 
					transfer_user_account.save
					Transaction.entry(transfer_user_account, "credit", params[:amount], params[:comment])
					redirect_to get_balance_path, notice: "Money has been transfer successfully."
				rescue Exception => e
					redirect_to transfer_money_path, alert: e.message
				end	
			else
				redirect_to transfer_money_path, alert: "Insufficient balance in your account."
			end	
		end	
	end

	def passbook
		@transactions = @account.transactions
	end

	private

	def set_account_and_balance
		@account = current_user.present? ? current_user.account : Account.none
		@balance = @account.current_balance if @account.present?
	end

	def set_transfer_user
		@transfer_to_user = User.find_by_id(params[:transfer_to])
	end
end