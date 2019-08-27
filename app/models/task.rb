class Task < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :tag_tasks, dependent: :destroy
  has_many :tags, through: :tag_tasks

  enum status: %i[to_do doing done achive]
  enum emergency_level: %i[unimportant important urgent]

  validates :user_id, :title, :status, :started_at, :deadline_at, :emergency_level, presence: true
  # validate :starte_time_later_than_deadline

  # search tasks with title or description logic
  scope :search_with, -> (search_params) do
    return all if search_params.blank?
    where('lower(title) LIKE ? OR lower(description) LIKE ?', "%#{search_params}%", "%#{search_params}%")
  end

  # select tasks with status logic
  scope :status_with, -> (select_status) do
    return all if select_status.blank?
    return none if !select_status.in?(Task.statuses.keys)
    try(select_status.to_sym)
  end

  # sort task logic
  scope :sort_by_date, -> (created_date_or_deadline_date) { order(created_date_or_deadline_date) }
  scope :sort_priority_by, -> (order = 'asc') { order(emergency_level: order) }

  # tag feature, getter and setter
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
