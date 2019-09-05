class Transaction < ApplicationRecord
  belongs_to :account

  def self.entry(account, transaction_type, amount, comment= nil)
  	self.create(account_id: account.try(:id), transaction_type: transaction_type, amount: amount.to_f, comment: comment)
  end
end
