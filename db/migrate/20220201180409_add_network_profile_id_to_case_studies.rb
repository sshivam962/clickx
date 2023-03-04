class AddNetworkProfileIdToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :network_profile_id, :integer
    add_index :case_studies, :network_profile_id
  end
end