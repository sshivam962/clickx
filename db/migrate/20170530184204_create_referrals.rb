class CreateReferrals < ActiveRecord::Migration[4.2]
  def change
    create_table :referrals do |t|
      t.integer :referrer_id
      t.integer :referee_id
      t.boolean :eligibility, default: false
      t.boolean :rewarded, default: false
      t.string :notes, default: ''

      t.timestamps null: false
    end
  end
end
