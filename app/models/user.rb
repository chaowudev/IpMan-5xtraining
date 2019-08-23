class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  enum role: %i[user admin]

  # validates_uniqueness_of :email
end
