require 'rails_helper'

RSpec.feature "TaskManagements", type: :feature do

  # scenario 'User creates a new task' do
  #   # 1. User visit route /tasks/new
  #   visit '/tasks/new'
  #   # 2. User fill in 6 columns(title, status, priority, started_at, deadline_at, description)
  #   fill_in 'task[title]', with: 'task test'
  #   find("option[value='to_do']", text: 'to_do').select_option
  #   find("option[value='unimportant']", text: 'unimportant').select_option
  #   within '.date-of-started-time-container' do
  #     find("option[value='2019']", text: '2019').select_option
  #     find("option[value='7']", text: 'July').select_option
  #     find("option[value='11']", text: '11').select_option
  #   end
  #   within '.date-of-deadline-time-container' do
  #     find("option[value='2019']", text: '2019').select_option
  #     find("option[value='7']", text: 'July').select_option
  #     find("option[value='12']", text: '12').select_option
  #   end
  #   fill_in 'task[description]', with: 'this is task test'
  #   # 3. click Create button
  #   click_button 'Create'
  #   # 4. Page show notice 'Create Success' 但透過 save_and_open_page 檢查後，畫面顯示的是 'Create Failure, please fill in all columns'
  #   expect(page).to have_content 'Create Success'
  #   save_and_open_page
  #   # 5. There has new task data in DB

  # end

end
