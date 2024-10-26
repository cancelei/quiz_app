class HomeController < ApplicationController
  def index
    if logged_in?
      @available_quizzes = current_user.accessible_quizzes
    end
  end
end
