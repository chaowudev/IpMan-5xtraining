class Task < ApplicationRecord
  belongs_to :user
  has_many :tag_tasks
  has_many :tags, through: :tag_tasks

  enum status: %i[to_do doing done achive]
  enum emergency_level: %i[unimportatn important urgent]

  validates :user_id, :title, :description, :status, :started_at, :deadline_at, :emergency_level, presence: true

end
