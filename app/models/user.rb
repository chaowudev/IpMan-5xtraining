class User < ApplicationRecord
  before_destroy :last_user?

  has_secure_password
  has_many :tasks, dependent: :destroy

  enum role: %i[user admin]

  # validates_uniqueness_of :email

  private

  def last_user?
    throws :abort if User.count < 1
  end
end
