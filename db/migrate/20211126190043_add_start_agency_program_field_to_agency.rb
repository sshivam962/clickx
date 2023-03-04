class AddStartAgencyProgramFieldToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :start_agency_program, :boolean, default: false
  end
end
