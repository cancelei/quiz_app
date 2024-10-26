class UserAnswer < ApplicationRecord
  belongs_to :user_quiz_attempt
  belongs_to :question
  belongs_to :answer
end
