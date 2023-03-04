class CreateWorkableWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :workable_webhooks do |t|
      t.string :target_url

      t.timestamps
    end
  end
end
