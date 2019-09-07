class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :account
  
  # active record callbacks
  after_create :open_user_account  

  # callback method to run after user create
  def open_user_account
    Account.create(user_id: self.id)   	
  end     
end