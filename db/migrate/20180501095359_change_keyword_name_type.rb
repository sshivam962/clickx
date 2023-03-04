class ChangeKeywordNameType < ActiveRecord::Migration[5.1]
  def up 
    change_column :domain_rankings, :keyword_name, :string
  end
  def down 
    change_column :domain_rankings, :keyword_name, :integer
  end
end
