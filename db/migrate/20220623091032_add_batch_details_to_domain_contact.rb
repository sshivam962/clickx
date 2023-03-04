class AddBatchDetailsToDomainContact < ActiveRecord::Migration[5.2]
  def change
    add_reference :domain_contacts, :cold_email_batch, foreign_key: true
    add_column :domain_contacts, :is_invalid_email, :boolean, default: false
    add_column :domain_contacts, :is_invalid_screenshot_url, :boolean, default: false
    add_column :domain_contacts, :image, :string
    add_column :lead_sources, :batch_size, :integer, default: 10
  end
end