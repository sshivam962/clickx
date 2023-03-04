class AddCalendlyScriptToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :calendly_script, :text
  end
end
