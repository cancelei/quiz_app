module ResultsHelper
  def score_color(score)
    case score
    when 90..100 then "text-green-600"
    when 70...90 then "text-blue-600"
    when 50...70 then "text-yellow-600"
    else "text-red-600"
    end
  end

  def answer_status_class(answer, user_selected)
    if user_selected && answer.correct?
      "bg-green-100 text-green-800"
    elsif user_selected && !answer.correct?
      "bg-red-100 text-red-800"
    elsif !user_selected && answer.correct?
      "bg-blue-100 text-blue-800"
    else
      "bg-gray-50"
    end
  end
end 