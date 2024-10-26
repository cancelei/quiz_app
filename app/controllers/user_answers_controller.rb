class UserAnswersController < ApplicationController
  def create
    @user_answer = UserAnswer.new(user_answer_params)
    @user_answer.user_quiz_attempt = UserQuizAttempt.find(params[:user_quiz_attempt_id])
    @user_answer.correct = @user_answer.answer.correct?

    if @user_answer.save
      redirect_to user_quiz_attempt_path(@user_answer.user_quiz_attempt), notice: 'Answer submitted.'
    else
      redirect_to user_quiz_attempt_path(@user_answer.user_quiz_attempt), alert: 'Error submitting answer.'
    end
  end

  private

  def user_answer_params
    params.require(:user_answer).permit(:question_id, :answer_id)
  end
end
