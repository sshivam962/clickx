class AddPrompt1Agencies < ActiveRecord::Migration[5.2]
  def change
  	add_column :agencies, :ai_bot_prompt_1, :string
  	add_column :agencies, :ai_bot_prompt_2, :string
  	add_column :agencies, :ai_bot_prompt_3, :string
  end
end
