FactoryBot.define do
  factory :quiz do
    title { "Sample Quiz" }
    time_limit { 30 }
    association :user
  end
end 