class AddUserReferencesToWebpushSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_reference :webpush_subscriptions, :user, index: true, foreign_key: true
  end
end
