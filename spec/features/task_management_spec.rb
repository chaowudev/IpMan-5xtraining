require 'rails_helper'

RSpec.feature "TaskManagements", type: :feature do
  let(:user) { create :user }
  let(:last_task) { Task.last }
  before do
    user
    user_login(user.email, user.password)
  end
  
  feature 'create task flow' do
    scenario 'User creates a new task' do
      click_on 'New Task'

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
        find("option[value='8']", text: 'August').select_option
        find("option[value='20']", text: '20').select_option
      end
      fill_in 'task[description]', with: 'this is task test'
      
      click_button 'Create'
      
      expect(page).to have_content 'Create Success'
      expect(Task.count).to eq 1
      validate_task_expectation(last_task)
    end
  end
  
  feature 'existence task flow' do
    let(:task) { create :task, user_id: user.id }
    before { task }

    scenario 'User reads task' do
      visit task_path(task)
      
      validate_task_expectation(task)  
    end
    
    scenario 'User edits task' do
      visit tasks_path
      click_link 'Edit'
      fill_in 'task[description]', with: 'test task updating'
      click_button 'Update'
      
      expect(page).to have_content 'Update Success'
      expect(Task.count).to eq 1
      expect(last_task.description).to eq 'test task updating'
    end

    scenario 'User deletes task' do
      visit tasks_path
      click_link 'Delete'
      
      # rails_helper: Capybara::DSL provide some methods
      expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure to delete this task?'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'Delete Success'
      expect(last_task).to be_nil
    end

    describe 'Sort task flow' do
      let(:first_task) { create :task, user_id: user.id, title: 'first task', emergency_level: 1, deadline_at: '2019-08-19', created_at: '2019-08-17 04:00:00' }
      let(:second_task) { create :task, user_id: user.id, title: 'second task', emergency_level: 2, deadline_at: '2019-08-18', created_at: '2019-08-17 06:00:00' }
      before do
        first_task
        second_task
      end

      scenario 'Default sorting by created_at' do
        visit tasks_path

        expect(page).to have_selector('.task-item', count: 3)
        expectation_sorting_by_created_at(page_items)
      end

      scenario 'Has correct order by created_at' do
        visit tasks_path
        click_link 'Created Date'

        expect(page).to have_selector('.task-item', count: 3)
        expectation_sorting_by_created_at(page_items)
      end

      scenario 'Has correct order by deadline_at' do
        visit tasks_path
        click_link 'Deadline Date'

        expect(page).to have_selector('.task-item', count: 3)
        expect(page_items[0]).to have_content second_task.title
        expect(page_items[1]).to have_content first_task.title
        expect(page_items[2]).to have_content task.title
      end

      scenario 'Has correct order by priority as asc' do
        visit tasks_path
        click_link 'Sort by Priority'

        expect(page).to have_selector('.task-item', count: 3)
        expect(page).to have_current_path('/tasks?direction=asc&sort=emergency_level')
        expect(page_items[0]).to have_content task.title
        expect(page_items[1]).to have_content first_task.title
        expect(page_items[2]).to have_content second_task.title
      end

      scenario 'Has correct order by priority as desc' do
        visit tasks_path
        click_link 'Sort by Priority'
        click_link 'Sort by Priority'

        expect(page).to have_selector('.task-item', count: 3)
        expect(page).to have_current_path('/tasks?direction=desc&sort=emergency_level')
        expect(page_items[0]).to have_content second_task.title
        expect(page_items[1]).to have_content first_task.title
        expect(page_items[2]).to have_content task.title
      end
    end

    describe 'Search task flow' do
      let(:chinese_task) { create :task, user_id: user.id, title: '中文', description: '這是中文任務描述', status: 1 }
      let(:english_task) { create :task, user_id: user.id, title: 'English', description: 'THIS IS ENGLISH TASK' }
      before do
        chinese_task
        english_task
        visit tasks_path
      end
      
      scenario 'Can search by task title as Chinese and search as doing' do  
        fill_in 'search', with: '中文'
        find("option[value='doing']", text: 'doing').select_option
        click_button 'Search'

        expect(page).to have_selector('.task-item', count: 1)
        expect(page).to have_content chinese_task.title
      end

      scenario 'Can search by task title as English and case insensitive' do  
        fill_in 'search', with: 'ENGLISH'
        click_button 'Search'

        expect(page).to have_selector('.task-item', count: 1)
        expect(page).to have_content english_task.title
      end

      scenario 'Can not search by task description as Chinese and status as to_do' do  
        fill_in 'search', with: '任務'
        find("option[value='to_do']", text: 'to_do').select_option
        click_button 'Search'

        expect(page).to have_selector('.task-item', count: 0)
      end

      scenario 'Can search by task description as English and case insensitive' do  
        fill_in 'search', with: 'TASK'
        click_button 'Search'

        expect(page).to have_selector('.task-item', count: 2)
        expect(page).to have_content task.title, english_task.title
      end
    end

    describe 'with single tasks' do
      scenario 'does not paginate'  do
        visit tasks_path
        
        expect(page).to have_selector('.task-item', count: 1)
        expect(page).to have_no_selector('.pagination')
      end
    end
    
    describe 'with six tasks and maximum tasks per page set to 5' do
      let(:test_task1) { create :task, user_id: user.id, title: 'test_task1' }
      let(:test_task2) { create :task, user_id: user.id, title: 'test_task2' }
      let(:test_task3) { create :task, user_id: user.id, title: 'test_task3' }
      let(:test_task4) { create :task, user_id: user.id, title: 'test_task4' }
      let(:last_task) { create :task, user_id: user.id, title: 'test pagination' }
      before do
        test_task1
        test_task2
        test_task3
        test_task4
        last_task
        visit tasks_path
      end

      scenario 'display 5 tasks in the first page' do
        expect(page).to have_selector('.pagination')
        expect(page).to have_selector('.task-item', count: 5)
      end

      scenario 'display 1 task in the second page' do
        within '.pagination' do
          click_link '2'
        end

        expect(page).to have_current_path('/tasks?page=2')
        expect(page).to have_selector('.task-item', count: 1)
      end
    end
  end

  def validate_task_expectation(task)
    expect(task.title).to eq 'task test'
    expect(task.status).to eq 'to_do' # -> 0 才是在 Model 的型態
    expect(task.emergency_level).to eq 'unimportant' # -> 0 才是在 Model 的型態
    expect(task.started_at.to_s).to eq '2019-07-11'
    expect(task.deadline_at.to_s).to eq '2019-08-20'
    expect(task.description).to eq 'this is task test'    
  end

  def page_items
    page.all('.task-item')
  end

  def expectation_sorting_by_created_at(items)
    expect(items[0]).to have_content task.title
    expect(items[1]).to have_content first_task.title
    expect(items[2]).to have_content second_task.title
  end

  def user_login(email, password)
    visit new_session_path
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button 'Log In'
  end
end
