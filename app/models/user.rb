class User < ApplicationRecord
  enum :role, { user: 0, admin: 1 }

  has_secure_password


  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :quiz_accesses, dependent: :destroy
  has_many :accessible_quizzes, through: :quiz_accesses, source: :quiz
  has_many :user_quiz_attempts, dependent: :destroy
  has_many :quizzes, dependent: :destroy

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end
end
