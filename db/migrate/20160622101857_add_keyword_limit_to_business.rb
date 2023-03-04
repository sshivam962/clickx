class AddKeywordLimitToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :keyword_limit, :integer, default: 100
  end
end
