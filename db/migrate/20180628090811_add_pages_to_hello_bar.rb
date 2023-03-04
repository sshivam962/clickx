class AddPagesToHelloBar < ActiveRecord::Migration[5.1]
  def change
    add_column :hello_bars, :pages_to_show, :jsonb, default: []
  end
end
