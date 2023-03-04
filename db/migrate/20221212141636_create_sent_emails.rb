class CreateSentEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :sent_emails do |t|
      t.text       :content
      t.string     :subject
      t.bigint     :sender_id
      t.bigint     :verified_by
      t.datetime   :verified_at
      t.datetime   :email_sent_at
      t.string     :from_email
      t.datetime   :email_opened_at
      t.datetime   :email_queued_at
      t.integer    :email_clicks_count, default: 0
      t.string     :sent_via_service

      t.references :domain_contact, foreign_key: true

      t.timestamps
    end
  end
end
