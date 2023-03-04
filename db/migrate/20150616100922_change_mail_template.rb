class ChangeMailTemplate < ActiveRecord::Migration[4.2]
  def change
    add_column :mail_templates, :welcome_text, :text, null: false, default: ""
    add_column :mail_templates, :agency_note, :text, null: false, default: ""
  end
end
