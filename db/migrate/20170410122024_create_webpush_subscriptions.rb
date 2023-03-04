class CreateWebpushSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :webpush_subscriptions do |t|
      t.string :endpoint
      t.string :p256dh
      t.string :auth
      t.boolean :user_visible_only, default: true

      t.timestamps null: false
    end
  end
end
