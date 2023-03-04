class AddDisplayCurrencyToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :display_currency, :string, default: 'USD'
  end
end
