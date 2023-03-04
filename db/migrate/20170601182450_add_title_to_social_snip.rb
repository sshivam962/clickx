class AddTitleToSocialSnip < ActiveRecord::Migration[4.2]
  def change
    add_column :social_snips, :title, :string, default: ''
  end
end
