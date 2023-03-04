class AddSubjectToMailTemplate < ActiveRecord::Migration[4.2]
  def change
    add_column :mail_templates, :subject, :string
  end
end
