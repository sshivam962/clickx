class AddReferredByToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :referred_by, :integer
  end
end
