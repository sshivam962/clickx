class AddImplementationFeesToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :implementation_fees, :boolean, default: true
  end
end
