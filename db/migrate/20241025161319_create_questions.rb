class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.text :content
      t.string :image_url
      t.boolean :multiple_correct_answers
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
