class AddCoachingCallsInSupportPageToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :coaching_calls_in_support_page, :boolean, default: false
  end
end
