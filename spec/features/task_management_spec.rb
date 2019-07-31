require 'rails_helper'

RSpec.feature "TaskManagements", type: :feature do
  # User need to sign in before task management
  let(:user) { User.create(email: 'ipman@test.com', password: '123123', role: 'user') }  # let 是懶惰方法
  before { user }
  
  feature 'create task flow' do
    scenario 'User creates a new task' do
      visit '/tasks/new'

      fill_in 'task[title]', with: 'task test'
      find("option[value='to_do']", text: 'to_do').select_option
      find("option[value='unimportant']", text: 'unimportant').select_option
      within '.date-of-started-time-container' do
        find("option[value='2019']", text: '2019').select_option
        find("option[value='7']", text: 'July').select_option
        find("option[value='11']", text: '11').select_option
      end
      within '.date-of-deadline-time-container' do
        find("option[value='2019']", text: '2019').select_option
        find("option[value='7']", text: 'July').select_option
        find("option[value='12']", text: '12').select_option
      end
      fill_in 'task[description]', with: 'this is task test'
      
      click_button 'Create'

      expect(page).to have_content 'Create Success'
      # 測試資料是否有生成要寫在 feature spec 還是 Model spec？
      expect(Task.count).to eq 1
      last_task = Task.last
      validate_last_task(last_task)
      # byebug
    end
  end
  
  feature 'existence task flow' do
    let(:task) { Task.create(user_id: user.id, title: 'task test', description: 'this is task test', status: 0, started_at: '2019-07-11', deadline_at: '2019-07-12', emergency_level: 0) }
    before { task }
    
    scenario 'User edits task' do
      visit tasks_path
      click_link 'Edit'  # click_on = click_button or click_link
      fill_in 'task[description]', with: 'test task updating'
      click_button 'Update'

      expect(page).to have_content 'Update Success'
      expect(Task.count).to eq 1
      expect(Task.last.description).to eq 'test task updating'
    end
  end

  def validate_last_task(task)
    # 驗證資料是否有寫入，是驗證 params[:task] 嗎？
    expect(task.title).to eq 'task test'
    expect(task.status).to eq 'to_do' # -> 0 才是在 Model 的型態
    expect(task.emergency_level).to eq 'unimportant' # -> 0 才是在 Model 的型態
    # 時間的部分不太清楚要怎麼驗證... 要再查一下...
    # expect(task.started_at).to eq '2019-07-11'
    # expect(task.deadline_at).to eq '2019-07-12'
    expect(task.description).to eq 'this is task test'    
  end

end
