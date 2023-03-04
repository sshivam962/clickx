class AddScaleProgramFieldToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :scale_program, :boolean, default: false
  end
end
