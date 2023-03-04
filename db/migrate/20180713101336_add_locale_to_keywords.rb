class AddLocaleToKeywords < ActiveRecord::Migration[5.1]
  def self.up
    add_column :keywords, :locale, :string
    SearchTerm.update_all(locale: 'en-us')
  end

  def self.down
    remove_column :keywords, :locale, :string
  end
end
