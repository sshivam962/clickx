class AddAgencyToLeadSource < ActiveRecord::Migration[5.1]
  def change
    add_reference :lead_sources, :agency, foreign_key: true
  end
end
