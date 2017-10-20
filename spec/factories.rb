# By using the symbol ':user', we get FactoryBot bot to simulate the User model.

FactoryBot.define do
  factory :user do
    name                  "Al Snow"
    email                 "jasnow@hotmail.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end

FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryBot.define do
  factory :micropost do
    content     "Foo bar"
    association :user
  end
end
