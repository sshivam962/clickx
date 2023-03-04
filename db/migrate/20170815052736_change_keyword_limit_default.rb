class ChangeKeywordLimitDefault < ActiveRecord::Migration[4.2]
  def up
    change_column_default :businesses, :keyword_limit, 10
  end

  def down
    change_column_default :businesses, :keyword_limit, 100
  end
end
