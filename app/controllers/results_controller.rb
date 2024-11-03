class ResultsController < ApplicationController
  before_action :set_quiz_attempt
  before_action :ensure_quiz_completed

  def show
    @quiz = @quiz_attempt.quiz
    @questions = @quiz.questions.includes(:answers)
    @user_answers = @quiz_attempt.user_answers.includes(:answer)

    respond_to do |format|
      format.html
      format.turbo_stream { 
        render turbo_stream: turbo_stream.update("quiz_content", 
          partial: "results/results",
          locals: { 
            quiz: @quiz,
            quiz_attempt: @quiz_attempt,
            questions: @questions,
            user_answers: @user_answers
          }
        )
      }
    end
  end

  private

  def set_quiz_attempt
    @quiz_attempt = UserQuizAttempt.find(params[:user_quiz_attempt_id])
  end

  def ensure_quiz_completed
    unless @quiz_attempt.completed?
      redirect_to quiz_path(@quiz_attempt.quiz), 
                  alert: "Please complete all questions before viewing the results."
    end
  end
end 