class Task < ApplicationRecord
  belongs_to :user
  has_many :tag_tasks, dependent: :destroy  # 在刪除任務的時候，會把相關的 tag 紀錄也一併刪除
  has_many :tags, through: :tag_tasks

  enum status: %i[to_do doing done achive]
  enum emergency_level: %i[unimportatn important urgent]

  validates :user_id, :title, :description, :status, :started_at, :deadline_at, :emergency_level, presence: true

end
