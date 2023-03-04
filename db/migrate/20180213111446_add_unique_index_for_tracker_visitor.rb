class AddUniqueIndexForTrackerVisitor < ActiveRecord::Migration[5.1]
  def change
    TrackerVisitor.group(:visitor_id,:business_id)
      .having("count(business_id) > 1")
      .count.map(&:first).each do |arr| 
        visitors =  Business.find(arr[1]).tracker_visitors.where(visitor_id: arr[0]).to_a
        visitors.shift
        visitors.map(&:delete)
      end
    add_index :tracker_visitors, [:visitor_id, :business_id], unique: true
  end
end
