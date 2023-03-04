class ChangeColumnNull < ActiveRecord::Migration[4.2]
  def change
    change_column_null :businesses, :timezone, default: 'Central Time (US & Canada)',:null => false
  end
end
