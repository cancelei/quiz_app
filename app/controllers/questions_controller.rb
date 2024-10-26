class QuestionsController < ApplicationController
  before_action :set_quiz
  before_action :set_question, only: %i[edit update destroy]
  before_action :require_admin

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      redirect_to quiz_path(@quiz), notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to quiz_path(@quiz), notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to quiz_path(@quiz), notice: 'Question was successfully deleted.'
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = @quiz.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content, :image_url, :multiple_correct_answers)
  end

  def require_admin
    redirect_to root_path, alert: 'Access restricted to admins only' unless current_user&.admin?
  end
end
