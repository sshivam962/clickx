class AddSubToTokens < ActiveRecord::Migration[4.2]
  def change
    add_column :tokens, :sub, :string
  end
end
