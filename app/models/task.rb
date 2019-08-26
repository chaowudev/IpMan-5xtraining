class Task < ApplicationRecord
  # validate :starte_time_later_than_deadline

  belongs_to :user, counter_cache: true
  has_many :tag_tasks, dependent: :destroy  # 在刪除任務的時候，會把相關的 tag 紀錄也一併刪除
  has_many :tags, through: :tag_tasks

  enum status: %i[to_do doing done achive]
  enum emergency_level: %i[unimportant important urgent]

  validates :user_id, :title, :status, :started_at, :deadline_at, :emergency_level, presence: true

  # search logic
  scope :search_or_select_with, -> (search_params, select_status) { where('lower(title) LIKE ? OR lower(description) LIKE ?', "%#{search_params}%", "%#{search_params}%").where(status: select_status) }

  # sort task logic
  scope :sort_by_date, -> (created_date_or_deadline_date) { order(created_date_or_deadline_date) }
  scope :sort_priority_by, -> (order = 'asc') { order(emergency_level: order) }

  # tag feature
  def self.tagged_with(name)
    Tag.find_by!(name: name).tasks
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |item|
      Tag.where(name: item.strip).first_or_create!
    end
  end

  # def starte_time_later_than_deadline
  #   errors.add(:deadline_at, I18n.t('activerecord.errors.messages.incorrect_deadline')) if deadline_at < started_at
  # end
end
