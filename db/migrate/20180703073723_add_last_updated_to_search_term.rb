class AddLastUpdatedToSearchTerm < ActiveRecord::Migration[5.1]
  def change
    add_column :keywords, :last_updated, :date
  end
end
