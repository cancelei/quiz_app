class UserQuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :user_answers, dependent: :destroy
  
  validates :quiz_id, :user_id, presence: true
end
