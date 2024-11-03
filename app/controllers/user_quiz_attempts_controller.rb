class UserQuizAttemptsController < ApplicationController
  before_action :set_quiz

  def create
    @user_quiz_attempt = current_user.user_quiz_attempts.build(quiz: @quiz)
    @user_quiz_attempt.attempted_at = Time.current

    if @user_quiz_attempt.save
      respond_to do |format|
        format.html { redirect_to quiz_user_quiz_attempt_question_path(@quiz, @user_quiz_attempt, 1) }
        format.turbo_stream { 
          redirect_to quiz_user_quiz_attempt_question_path(@quiz, @user_quiz_attempt, 1), 
                      turbo_stream: true 
        }
      end
    else
      redirect_to quizzes_path, alert: 'Unable to start quiz attempt.'
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
