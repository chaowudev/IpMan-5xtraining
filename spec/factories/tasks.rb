FactoryBot.define do
  factory :task do
    association :user
    title { 'task test' }
    description { 'this is task test' }
    status { 0 }
    started_at { '2019-07-11' }
    deadline_at { '2019-08-20' }
    emergency_level { 0 }
    created_at { '2019-07-11 13:00:10' }
  end
end