class QuizQuestionsController < ApplicationController
  before_action :set_quiz
  before_action :set_quiz_attempt
  before_action :set_question_number

  def show
    @total_questions = @quiz.questions.count
    @question = @quiz.questions[@question_number - 1]

    respond_to do |format|
      format.html { render layout: true }
      format.turbo_stream
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_quiz_attempt
    @quiz_attempt = UserQuizAttempt.find(params[:user_quiz_attempt_id])
  end

  def set_question_number
    @question_number = params[:id].to_i
  end
end 