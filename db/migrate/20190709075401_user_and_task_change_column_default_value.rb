class UserAndTaskChangeColumnDefaultValue < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :role, from: nil, to: 0  # role = user
    change_column_default :tasks, :status, from: nil, to: 0  # status = to_do
    change_column_default :tasks, :emergency_level, from: nil, to: 0  # emergency_level = unimportant
  end
end
