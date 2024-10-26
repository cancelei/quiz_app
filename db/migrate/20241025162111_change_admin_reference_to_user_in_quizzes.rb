class ChangeAdminReferenceToUserInQuizzes < ActiveRecord::Migration[8.0]
  def change
    remove_reference :quizzes, :admin, foreign_key: true
    add_reference :quizzes, :user, foreign_key: true
  end
end
