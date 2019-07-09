class User < ApplicationRecord
  has_many :tasks

  enum role: %i[user admin]

end
