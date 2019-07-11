require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'the informations of task must be presence' do
    it 'task has user_id, title, description, status, started_at, deadline_at, emergency_level' do
      task = Task.new(user_id: 1, title: 'task test', description: 'this is task test', status: 0, started_at: '2019-07-11', deadline_at: '2019-07-12', emergency_level: 0)
      should validate_presence_of :user_id
      should validate_presence_of :title
      should validate_presence_of :description
      should validate_presence_of :status
      should validate_presence_of :started_at
      should validate_presence_of :deadline_at
      should validate_presence_of :emergency_level
    end
  end
  
end