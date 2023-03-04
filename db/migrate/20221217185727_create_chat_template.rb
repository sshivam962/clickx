class CreateChatTemplate < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_templates do |t|
      t.string :template_name
      t.string :template_data
    end
  end
end
