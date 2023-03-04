class AddLastVisitedTimeToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :keywords_last_viewed_at, :datetime
  end
end
