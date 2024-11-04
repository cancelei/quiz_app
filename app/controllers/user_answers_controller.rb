class UserAnswersController < ApplicationController
  before_action :set_quiz
  before_action :set_quiz_attempt

  def create
    # Delete previous answers for this question if they exist
    UserAnswer.where(
      user_quiz_attempt: @quiz_attempt,
      question_id: params[:question_id]
    ).destroy_all

    # Create new answers
    if params[:answer_ids].present?
      params[:answer_ids].each do |answer_id|
        UserAnswer.create!(
          question_id: params[:question_id],
          answer_id: answer_id,
          user_quiz_attempt: @quiz_attempt,
          correct: Answer.find(answer_id).correct?
        )
      end
    end

    # Handle quiz completion
    if params[:commit] == "Finish Quiz"
      complete_quiz
      respond_to do |format|
        format.html { redirect_to quiz_user_quiz_attempt_results_path(@quiz, @quiz_attempt) }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("quiz_content", 
            partial: "results/results",
            locals: { 
              quiz: @quiz,
              quiz_attempt: @quiz_attempt,
              questions: @quiz.questions.includes(:answers),
              user_answers: @quiz_attempt.user_answers.includes(:answer)
            }
          )
        }
      end
    else
      # Continue to next question
      next_question = params[:question_number].to_i + 1
      redirect_to quiz_user_quiz_attempt_question_path(@quiz, @quiz_attempt, next_question), 
                  turbo_frame: "quiz_content"
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_quiz_attempt
    @quiz_attempt = UserQuizAttempt.find(params[:user_quiz_attempt_id])
  end

  def complete_quiz
    total_score = 0
    total_questions = @quiz.questions.count

    @quiz.questions.each do |question|
      # Get all possible correct answers for this question
      total_correct_answers = question.answers.where(correct: true).count
      next if total_correct_answers.zero?

      # Get user's answers for this question
      user_answers = @quiz_attempt.user_answers.where(question: question)
      user_correct_answers = user_answers.where(correct: true).count
      user_incorrect_answers = user_answers.where(correct: false).count

      # Calculate score for this question
      if user_incorrect_answers.zero? && user_correct_answers > 0
        question_score = (user_correct_answers.to_f / total_correct_answers) * 100
        total_score += question_score
      end
    end

    # Calculate final average score
    final_score = (total_score / total_questions).round(2)

    @quiz_attempt.update!(
      completed: true,
      completed_at: Time.current,
      score: final_score
    )
  end
end
