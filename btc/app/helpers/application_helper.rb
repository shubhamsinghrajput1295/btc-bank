module ApplicationHelper

	def check_amount(balance, withdraw_money)
		if balance.to_f >= withdraw_money.to_s.to_f
			return true
		else
			return false
		end
	end
end
