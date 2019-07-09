class Task < ApplicationRecord
  belongs_to :user

  has_many :tag_tasks
  has_many :tags, through: :tag_tasks

  enum status: %i[to_do doing done achive]
  enum emergency_level: %i[unimportatn important urgent]

end
