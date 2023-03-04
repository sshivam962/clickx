class ChangeColumnForBusinessHours < ActiveRecord::Migration[4.2]
  def up
    remove_column :business_hours, :from
    remove_column :business_hours, :to

    add_column :business_hours, :from, :string, null: false, default: ''
    add_column :business_hours, :to, :string, null: false, default: ''
  end

  def down
    remove_column :business_hours, :from
    remove_column :business_hours, :to

    add_column :business_hours, :from, :time
    add_column :business_hours, :to, :time
  end
end
