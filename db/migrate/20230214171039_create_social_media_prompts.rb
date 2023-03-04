class CreateSocialMediaPrompts < ActiveRecord::Migration[5.2]
  def change
    create_table :social_media_prompts do |t|
      t.string :title
      t.string :prompt
    end
  end
end
