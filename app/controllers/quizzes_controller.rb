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

  def add_question
    @quiz = Quiz.new
    @question = @quiz.questions.build

    helpers.form_with(model: @quiz, local: true) do |form|
      @form = form
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def add_answer
    Rails.logger.debug "Params: #{params.inspect}" # Log the parameters
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build
    respond_to do |format|
      format.turbo_stream
    end
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
