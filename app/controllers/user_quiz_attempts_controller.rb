class UserQuizAttemptsController < ApplicationController
  def create
    @quiz = Quiz.find(params[:quiz_id])
    @user_quiz_attempt = current_user.user_quiz_attempts.build(quiz: @quiz)
    @user_quiz_attempt.attempted_at = Time.current

    if @user_quiz_attempt.save
      redirect_to user_quiz_attempt_path(@user_quiz_attempt), notice: 'Quiz attempt started.'
    else
      redirect_to quizzes_path, alert: 'Unable to start quiz attempt.'
    end
  end

  def show
    @user_quiz_attempt = UserQuizAttempt.find(params[:id])
    @questions = @user_quiz_attempt.quiz.questions
  end
end
