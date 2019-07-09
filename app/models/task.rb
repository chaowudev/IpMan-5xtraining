class Task < ApplicationRecord
  belongs_to :user

  has_many :tag_tasks
  has_many :tags, through: :tag_tasks

  enum status: { to_do: 0, doing: 1, done: 2, achive: 3 }
  enum emergency_level: { unimportant: 0, important: 1, urgent: 2 }

end
