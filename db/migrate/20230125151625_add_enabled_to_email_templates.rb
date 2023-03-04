class AddEnabledToEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :email_templates, :enabled, :boolean, default: true
  end
end
