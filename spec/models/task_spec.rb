require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { create :task }
  before { task }

  describe 'the informations of task must be presence' do
    it 'user must exist' do
      task.user_id = nil
      task.valid?
      expect(task.errors[:user]).to include 'must exist'
    end

    it 'task has user_id, title, status, started_at, deadline_at, emergency_level' do
      should validate_presence_of :user_id
      should validate_presence_of :title
      should validate_presence_of :status
      should validate_presence_of :started_at
      should validate_presence_of :deadline_at
      should validate_presence_of :emergency_level
    end

    it 'title cant\'t not be blank' do
      task.title = nil
      task.valid?
      expect(task.errors[:title]).to include 'can\' t be blank!'
    end
  end

  describe 'default value must exist' do
    it 'status has default value' do
      expect(task.status).to eq 'to_do'
    end

    it 'emergency_level has default value' do
      expect(task.emergency_level).to eq 'unimportant'
    end
  end

  describe 'enum can work' do
    it 'enum of status can work' do
      task.status = 2
      expect(task.status).to eq 'done'
    end

    it 'enum of emergency_level can work' do
      task.emergency_level = 2
      expect(task.emergency_level).to eq 'urgent'
    end
  end
  
end