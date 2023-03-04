class CreateAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :answers do |t|
      t.string :answer
      t.string :oneliner
      t.string :multiline, :string, array: true, default: []
      t.boolean :boolean_ans

      t.timestamps null: false
    end
  end
end
