class AddIndexToBeSearchedColumns < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :title
    add_index :tasks, :description
    add_index :tasks, :status
  end
end