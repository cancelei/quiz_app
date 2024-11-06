class UserQuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  has_many :user_answers, dependent: :destroy

  # Public methods
  def completed?
    completed_at.present?
  end

  def calculate_score
    total_questions = quiz.questions.count
    total_score = quiz.questions.sum do |question|
      calculate_question_score(question)
    end

    self.score = (total_score / total_questions * 100).round(2)
  end

  private

  def calculate_question_score(question)
    user_selected_answers = user_answers.where(question: question).includes(:answer)
    correct_answers = question.answers.where(correct: true)
    total_correct = correct_answers.count
    total_incorrect = question.answers.where(correct: false).count
    
    return 0 if user_selected_answers.empty?

    selected_correct = user_selected_answers.count { |ua| ua.answer.correct? }
    selected_incorrect = user_selected_answers.count { |ua| !ua.answer.correct? }

    if total_correct > 1
      calculate_multiple_correct_score(
        selected_correct: selected_correct,
        selected_incorrect: selected_incorrect,
        total_correct: total_correct,
        total_incorrect: total_incorrect
      )
    else
      calculate_single_correct_score(
        selected_correct: selected_correct,
        selected_incorrect: selected_incorrect,
        total_incorrect: total_incorrect
      )
    end
  end

  def calculate_multiple_correct_score(selected_correct:, selected_incorrect:, total_correct:, total_incorrect:)
    correct_score = selected_correct.to_f / total_correct
    incorrect_penalty = selected_incorrect.to_f / total_incorrect

    # Ensure the score doesn't go below zero
    [(correct_score - incorrect_penalty), 0].max.round(2)
  end

  def calculate_single_correct_score(selected_correct:, selected_incorrect:, total_incorrect:)
    if selected_correct == 1
      # Partial credit for correct answer even if some incorrect ones are selected
      penalty = selected_incorrect.to_f / total_incorrect
      [(1.0 - penalty), 0].max.round(2)
    else
      0.0 # No credit if no correct answer selected
    end
  end
end
