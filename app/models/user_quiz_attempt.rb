class UserQuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
end
