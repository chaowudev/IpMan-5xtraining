require 'rails_helper'

RSpec.feature "TaskManagements", type: :feature do
  # User need to sign in before task management
  let(:user) { create :user }  # let 是懶惰方法
  let(:last_task) { Task.last }
  before { user }
  
  feature 'create task flow' do
    scenario 'User creates a new task' do
      visit new_task_path

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
    let(:task) { create :task }
    before { task }

    scenario 'User reads task' do
      visit task_path(task)
      
      validate_task_expectation(task)  
    end
    
    scenario 'User edits task' do
      visit tasks_path
      click_link 'Edit'  # click_on = click_button or click_link
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

    describe 'Sort task by date' do
      let(:first_task) { create :task, title: 'first task', deadline_at: '2019-08-19', created_at: '2019-08-17 04:00:00' }
      let(:second_task) { create :task, title: 'second task', deadline_at: '2019-08-18', created_at: '2019-08-17 06:00:00' }

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
end
