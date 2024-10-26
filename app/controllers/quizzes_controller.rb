class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show edit update destroy]
  before_action :require_admin, only: %i[new create edit update destroy]

  def index
    @quizzes = Quiz.all
  end

  def show
    # @quiz is set by `set_quiz`
    @questions = @quiz.questions
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: 'Quiz was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: 'Quiz was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_path, notice: 'Quiz was successfully deleted.'
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description, :time_limit)
  end

  def require_admin
    redirect_to root_path, alert: 'Access restricted to admins only' unless current_user&.admin?
  end
end
