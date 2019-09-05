class AccountsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_account
	before_action :set_transfer_user, only: [:send_transfer_money]
	include ApplicationHelper
	def index	
	end

	def get_balance
	end

	def deposit_money
	end

	def save_deposit_money
		deposit_money = @balance.to_f + params[:deposit_money].to_f 
		@account.current_balance = deposit_money
		if @account.save
			Transaction.entry(@account, "credit", params[:deposit_money])
			redirect_to get_balance_path, notice: "Money Desposited successfully."
		else
			render :deposit_money, alert: @account.errors.full_message
		end
	end

	def withdraw_money
	end

	def debit_money
		amount  = check_amount(@balance, params[:withdraw_money])
		if amount 
			withdraw_money = @balance.to_f - params[:withdraw_money].to_f 
			@account.current_balance = withdraw_money
			if @account.save
				Transaction.entry(@account, "debit", params[:withdraw_money])
				redirect_to get_balance_path, notice: "Money withdraw successfully."
			else
				render :withdraw_money, alert: @account.errors.full_message
			end
		else
			redirect_to get_balance_path, alert: "Insufficient balance in your account."
		end	
	end

	def transfer_money
		@users = User.where.not(id: current_user.try(:id))
	end

	def send_transfer_money
		amount  = check_amount(@balance, params[:amount])
		if amount 
			withdraw_money = @balance.to_f - params[:amount].to_f 
			@account.current_balance = withdraw_money
			if @account.save
				Transaction.entry(@account, "debit", params[:amount], params[:comment])

				transfer_user_account = @transfer_to_user.accounts.first
				transfer_user_balance = transfer_user_account.current_balance.present? ? transfer_user_account.current_balance : 0.0
				transfer_amount = transfer_user_balance.to_f + params[:amount].to_f 
				transfer_user_account.current_balance = transfer_amount
				if transfer_user_account.save
					Transaction.entry(transfer_user_account, "credit", params[:amount], params[:comment])
					redirect_to get_balance_path, notice: "Money transfer successfully."
				else
					render :withdraw_money, alert: @account.errors.full_message
				end	
			else
				render :withdraw_money, alert: @account.errors.full_message
			end
		else
			redirect_to transfer_money_path, alert: "Insufficient balance in your account to transfer money."
		end
	end

	def passbook
		@transactions = @account.transactions
	end

	private

	def set_account
		if current_user.present?
			@account = current_user.accounts.first
			@balance = @account.current_balance.present? ? @account.current_balance : 0.0
		end
	end

	def set_transfer_user
		@transfer_to_user = User.find_by_id(params[:transfer_to])
		if not @transfer_to_user.present?
			redirect_to transfer_money_path, alert: "No user found."
		end
	end
end