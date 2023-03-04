class AddDomainFieldToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :domain, :string
    add_column :agencies, :weburl, :string
    add_column :agencies, :white_label_name, :string
    add_column :agencies, :white_labeled, :boolean, default: false
  end
end
