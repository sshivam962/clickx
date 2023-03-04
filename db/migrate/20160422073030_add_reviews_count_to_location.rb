class AddReviewsCountToLocation < ActiveRecord::Migration[4.2]
  def up
    add_column :locations, :reviews_count, :integer
    Location.find_each { |location| Location.reset_counters(location.id, :reviews) }
  end

  def down
    remove_column :locations, :reviews_count
  end
end
