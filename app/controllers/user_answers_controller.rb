class UserAnswersController < ApplicationController
  before_action :set_quiz

  def create
    # {"authenticity_token"=>"[FILTERED]", "question_id"=>"1", "answer_ids"=>["1", "2"], "commit"=>"Submit Answers", "quiz_id"=>"1", "user_quiz_attempt_id"=>"3"}
    params[:answer_ids].each do |answer_id|
      @user_answer = UserAnswer.new(question_id: params[:question_id], answer_id: answer_id, user_quiz_attempt_id: params[:user_quiz_attempt_id])
      @user_answer.correct = @user_answer.answer.correct?
    end

    if @user_answer.save
      redirect_to quiz_user_quiz_attempt_path(@quiz, @user_answer.user_quiz_attempt), notice: 'Answer submitted.'
    else
      redirect_to quiz_user_quiz_attempt_path(@quiz, @user_answer.user_quiz_attempt), alert: 'Error submitting answer.'
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
