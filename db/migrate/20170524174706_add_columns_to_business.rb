class AddColumnsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :show_facebook_profile, :boolean, :default => true
    add_column :businesses, :show_linkedin_profile, :boolean, :default => true
  end
end
