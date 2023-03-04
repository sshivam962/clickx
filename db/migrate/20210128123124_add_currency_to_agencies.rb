class AddCurrencyToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :currency, :string, default: '$'
  end
end
