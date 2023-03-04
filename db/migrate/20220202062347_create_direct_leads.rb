class CreateDirectLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :direct_leads do |t|
      t.string :name
      t.string :base_domain
      t.string :base_url
      t.string :root_url
      t.references :lead_source
      t.datetime :viewed_at
      t.integer :domain_contacts_count, default: 0
      t.boolean :mark_as_send, default: false
      t.boolean :emailed, default: false
      t.bigint :contacted_by_id
      t.bigint :skipped_by_id
      t.datetime :contacted_at
      t.datetime :skipped_at
      t.datetime :blocked_at
      t.boolean :wordpress
      t.datetime :voice_mailed_at
      t.bigint :voice_mailed_by

      t.timestamps
    end
  end
end
