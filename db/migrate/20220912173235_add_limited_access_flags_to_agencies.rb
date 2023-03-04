class AddLimitedAccessFlagsToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :portfolio_limited_access, :boolean, default: false
    add_column :agencies, :case_study_limited_access, :boolean, default: false
  end
end
