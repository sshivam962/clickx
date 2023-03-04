class AddCalendlyScriptToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :calendly_script, :text
  end
end
