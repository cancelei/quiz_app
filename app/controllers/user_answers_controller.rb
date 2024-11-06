class UserAnswersController < ApplicationController
  before_action :set_quiz
  before_action :set_quiz_attempt

  def create
    # Clear previous answers for this question
    @quiz_attempt.user_answers.where(question_id: params[:question_id]).destroy_all

    # Create new answers
    if params[:answer_ids].present?
      Array(params[:answer_ids]).each do |answer_id|
        @quiz_attempt.user_answers.create!(
          question_id: params[:question_id],
          answer_id: answer_id
        )
      end
    end

    if params[:commit] == "Finish Quiz"
      complete_quiz
      redirect_to quiz_user_quiz_attempt_results_path(@quiz, @quiz_attempt), 
                  turbo_frame: "quiz_content"
    else
      next_question = params[:question_number].to_i + 1
      redirect_to quiz_user_quiz_attempt_question_path(@quiz, @quiz_attempt, next_question), 
                  turbo_frame: "quiz_content"
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_quiz_attempt
    @quiz_attempt = UserQuizAttempt.find(params[:user_quiz_attempt_id])
  end

  def complete_quiz
    @quiz_attempt.completed_at = Time.current
    @quiz_attempt.calculate_score
    @quiz_attempt.save!
  end
end
