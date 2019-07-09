class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :description
      t.integer :status
      t.date :started_at
      t.date :deadline_at
      t.integer :emergency_level

      t.timestamps
    end
  end
end
