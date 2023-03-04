class AddActiveToHelloBar < ActiveRecord::Migration[4.2]
  def change
    add_column :hello_bars , :active, :boolean, default: false
  end
end
