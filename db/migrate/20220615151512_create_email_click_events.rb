class CreateEmailClickEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :email_click_events do |t|
      t.datetime :clicked_at
      t.string :sg_event_id
      t.json :metadata, default: {}

      t.references :domain_contact
    end
  end
end
