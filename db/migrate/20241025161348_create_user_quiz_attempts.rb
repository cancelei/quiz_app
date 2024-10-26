class CreateUserQuizAttempts < ActiveRecord::Migration[8.0]
  def change
    create_table :user_quiz_attempts do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :completed
      t.decimal :score
      t.datetime :attempted_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
