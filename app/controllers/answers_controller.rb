class AnswersController < ApplicationController
  before_action :set_quiz
  before_action :set_question
  before_action :set_answer, only: %i[edit update destroy]
  before_action :require_admin

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to quiz_path(@question.quiz), notice: 'Answer was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to quiz_path(@question.quiz), notice: 'Answer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_back fallback_location: quiz_path(@question.quiz), notice: 'Answer was successfully deleted.'
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, :correct)
  end

  def require_admin
    redirect_to root_path, alert: 'Access restricted to admins only' unless current_user&.admin?
  end
end
