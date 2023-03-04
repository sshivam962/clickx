class RemoveColumnsSocialSnips < ActiveRecord::Migration[4.2]
  def change
    remove_column :social_snips, :logo,         :string
    remove_column :social_snips, :content,      :string
    remove_column :social_snips, :brand_name,   :string
    remove_column :social_snips, :button_link,  :string
    remove_column :social_snips, :button_text,  :string
    remove_column :social_snips, :business_id,  :integer
    add_column    :social_snips, :template_id,  :integer
  end
end