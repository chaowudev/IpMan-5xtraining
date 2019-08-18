class Task < ApplicationRecord
  # validate :starte_time_later_than_deadline

  belongs_to :user
  has_many :tag_tasks, dependent: :destroy  # 在刪除任務的時候，會把相關的 tag 紀錄也一併刪除
  has_many :tags, through: :tag_tasks

  enum status: %i[to_do doing done achive]
  enum emergency_level: %i[unimportant important urgent]

  validates :user_id, :title, :status, :started_at, :deadline_at, :emergency_level, presence: true

  # search logic 分頁功能做完後要把 limit method 拿掉
  scope :search_title_and_description, -> (search_params) { where('lower(title) LIKE ? OR lower(description) LIKE ?', "%#{search_params}%", "%#{search_params}%").limit(20) }

  # sort task logic 分頁功能做完後要把 limit method 拿掉
  scope :sort_by_date, -> (created_date_or_deadline_date) { order(created_date_or_deadline_date).limit(20) }

  # def starte_time_later_than_deadline
  #   errors.add(:deadline_at, I18n.t('activerecord.errors.messages.incorrect_deadline')) if deadline_at < started_at
  # end

end
