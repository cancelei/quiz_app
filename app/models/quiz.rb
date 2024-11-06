class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :quiz_accesses, dependent: :destroy
  has_many :user_quiz_attempts, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :time_limit, presence: true

  def upload_csv(csv_file)
    csv_file.read.split("\n").each do |line|
      content, correct, *answers = line.split(",")
      questions.build(content: content, answers_attributes: answers.map { |answer| { content: answer, correct: correct.split(";").map(&:strip).include?(answer.strip) } })
    end
  end

  def total_questions
    questions.count
  end
end
