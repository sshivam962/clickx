class SetThePublishAndRequiredFieldToFalseValue < ActiveRecord::Migration[5.1]
  def change
    change_column :questions, :is_published, :boolean, default: false
    change_column :questions, :is_mandatory , :boolean, default: false
  end
end
