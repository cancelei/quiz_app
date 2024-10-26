class Quiz < ApplicationRecord
  belongs_to :user # now references the User model instead of Admin
  has_many :questions, dependent: :destroy
  has_many :quiz_accesses, dependent: :destroy
  has_many :user_quiz_attempts, dependent: :destroy

  validates :title, :time_limit, presence: true
end
