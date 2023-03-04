class CreateAgencyProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :agency_profiles do |t|
      t.references :agency, foreign_key: true
      t.string :estd_date
      t.string :core_services
      t.string :value_proposition
      t.string :preferred_niche
      t.text :niche_description
      t.text :niche_lookup_keyword
      t.text :customer_pain_points
      t.text :decision_makers
      t.text :niche_directories
      t.string :client_call_source
      t.text :challenges
      t.string :monthly_revenue
      t.text :monthly_revenue_goal

      t.timestamps
    end
  end
end
