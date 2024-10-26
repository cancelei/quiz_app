class CreateQuizAccesses < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_accesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
