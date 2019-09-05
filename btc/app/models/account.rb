class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  # active record callbacks
  before_create :create_unique_account_number

  # callback method to run after account create
  def create_unique_account_number
    number = SecureRandom.alphanumeric
    if number.present?
      while Account.find_by(account_number: number)
        number = SecureRandom.alphanumeric
      end
    end
    self.account_number = number
  end
end
