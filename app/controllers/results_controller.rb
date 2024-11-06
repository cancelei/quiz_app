class ResultsController < ApplicationController
  before_action :set_quiz_attempt
  before_action :ensure_quiz_completed

  def show
    respond_to do |format|
      format.html
      format.turbo_stream { 
        render turbo_stream: turbo_stream.update("quiz_content", 
          partial: "results/results"
        )
      }
    end
  end

  private

  def set_quiz_attempt
    @quiz_attempt = UserQuizAttempt.includes(
      quiz: { questions: :answers },
      user_answers: :answer
    ).find(params[:user_quiz_attempt_id])
  end

  def ensure_quiz_completed
    unless @quiz_attempt.completed?
      redirect_to quiz_path(@quiz_attempt.quiz), 
                  alert: "Please complete all questions before viewing results"
    end
  end
end 