class CreateQuizzes < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.integer :time_limit
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
