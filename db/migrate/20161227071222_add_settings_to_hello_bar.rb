class AddSettingsToHelloBar < ActiveRecord::Migration[4.2]
  def change
    add_column :hello_bars, :settings, :jsonb, default: {}
    add_column :hello_bars, :template, :text
  end
end
