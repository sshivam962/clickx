class AddTypeToKeywords < ActiveRecord::Migration[5.1]
  def change
    add_column :keywords, :type, :string

    KeywordBase.update_all(type: 'Keyword')
  end
end
