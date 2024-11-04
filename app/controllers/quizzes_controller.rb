class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show edit update destroy]
  before_action :require_admin, only: %i[new create edit update destroy]

  def index
    @quizzes = Quiz.all
  end

  def show
    @questions = @quiz.questions.includes(:answers)
  end

  def new
    @quiz = Quiz.new
    @quiz.questions.build.answers.build
  end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    upload_csv
    if @quiz.save
      redirect_to @quiz, notice: 'Quiz was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    upload_csv
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

  def upload_csv
    @quiz.upload_csv(params[:quiz][:csv_file]) if params[:quiz][:csv_file].present?
    flash[:notice] = @quiz.errors.any? ? 'Failed to upload CSV' : 'CSV uploaded successfully'
  end

  private

  def set_quiz
    # Only find the quiz if the action is not add_question
    return if action_name == 'add_question'
    
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description, :time_limit,
      questions_attributes: [:id, :content, :_destroy,
        answers_attributes: [:id, :content, :correct, :_destroy]])
  end

  def require_admin
    redirect_to root_path, alert: 'Access restricted to admins only' unless current_user&.admin?
  end
end
