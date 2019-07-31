FactoryBot.define do
  factory :task do
    user_id { user_id }
    title { 'task test' }
    description { 'this is task test' }
    status { 0 }
    started_at { '2019-07-11' }
    deadline_at { '2019-07-12' }
    emergency_level { 0 }
  end
end