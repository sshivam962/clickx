class UpdateSequentialIdInTrackerVisitors < ActiveRecord::Migration[4.2]
  def up
    execute "UPDATE tracker_visitors SET sequential_id = row_number
    FROM (
        SELECT id, ROW_NUMBER() OVER (partition BY business_id ORDER BY created_at ASC)
          FROM tracker_visitors
    ) v2
    WHERE tracker_visitors.id = v2.id"
  end
end
