class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  # active record callbacks
  before_create :create_unique_account_number

  # callback method to run after account create
  def create_unique_account_number
    number = SecureRandom.alphanumeric
    while Account.find_by_account_number(number)
      number = SecureRandom.alphanumeric
    end
    self.account_number = number
  end

  def check_amount(balance, withdraw_money)
    balance.to_f >= withdraw_money.to_s.to_f ? true : false
  end
end
