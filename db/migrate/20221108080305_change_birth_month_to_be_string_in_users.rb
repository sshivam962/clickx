class ChangeBirthMonthToBeStringInUsers < ActiveRecord::Migration[5.2]
  def change
  	change_column :users, :birth_month, :string
  	change_column :users, :birth_day, :string
  end
end
