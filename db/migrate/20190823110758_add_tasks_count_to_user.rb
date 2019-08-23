class AddTasksCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tasks_count, :integer, default: 0

    User.pluck(:id).each do |i|
      User.reset_counters(i, :tasks)  # 全部重算一次
    end
  end
end
