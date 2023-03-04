class AddMomentCallToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :moment_call, :boolean, default: false
  end
end