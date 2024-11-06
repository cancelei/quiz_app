FactoryBot.define do
  factory :question do
    content { "What is the capital of France?" }
    association :quiz
  end
end 