module ResultsHelper
  def answer_status_class(answer, user_selected)
    if user_selected
      if answer.correct?
        "bg-green-100 text-green-800" # Correct answer, user selected
      else
        "bg-red-100 text-red-800" # Wrong answer, user selected
      end
    elsif answer.correct?
      "bg-blue-100 text-blue-800" # Correct answer, user didn't select
    else
      "bg-gray-50 text-gray-800" # Wrong answer, user didn't select
    end
  end
end 