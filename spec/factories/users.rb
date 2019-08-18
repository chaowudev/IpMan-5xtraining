FactoryBot.define do
  factory :user do
    email { "ipman@test.com" }
    password { "123123" }
    role { "user" }
  end
end