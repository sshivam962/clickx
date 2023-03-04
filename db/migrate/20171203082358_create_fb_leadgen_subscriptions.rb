class CreateFbLeadgenSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_leadgen_subscriptions do |t|
      t.string :page_id
      t.references :business, foreign_key: true

      t.timestamps
    end
  end
end
