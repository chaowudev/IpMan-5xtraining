class User < ApplicationRecord
  has_many :tasks

  enum role: { user: 0, admin: 1 }

end
