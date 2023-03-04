class AddSignupApprovedToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :signup_approved, :boolean, default: true
  end
end
