class CreateDomainContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :domain_contacts do |t|
      t.string :name
      t.string :title
      t.string :company
      t.string :email
      t.string :base_domain
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.text :email_content
      t.references :sender, index: true, foreign_key: {to_table: :users} 
      t.datetime :email_sent_at
      t.string :contactable_type
      t.integer :verified_by
      t.datetime :verified_at
      t.boolean :unsubscribed, :boolean, default: false
      t.datetime :email_opened_at
      t.integer :email_clicks_count
      t.string :email_sent_from
      t.bigint :rejected_by_id
      t.datetime :rejected_at
      t.integer :status, default: 0
    
    
      t.timestamps      
    end
  end
end
