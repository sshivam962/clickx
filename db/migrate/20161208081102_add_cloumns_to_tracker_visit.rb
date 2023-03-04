class AddCloumnsToTrackerVisit < ActiveRecord::Migration[4.2]
  def change
	add_column :tracker_visits,:os,:string
	add_column :tracker_visits,:ip,:inet
	add_column :tracker_visits,:city,:string
	add_column :tracker_visits,:region,:string
	add_column :tracker_visits,:browser,:string
	add_column :tracker_visits,:country,:string
	add_column :tracker_visits,:latitude,:decimal, {:precision=>10, :scale=>6}
	add_column :tracker_visits,:location,:jsonb
	add_column :tracker_visits,:platform,:string
	add_column :tracker_visits,:referrer,:string
	add_column :tracker_visits,:utm_term,:string
	add_column :tracker_visits,:longitude,:decimal, {:precision=>10, :scale=>6}
	add_column :tracker_visits,:user_agent,:string
	add_column :tracker_visits,:utm_medium,:string
	add_column :tracker_visits,:utm_source,:string
	add_column :tracker_visits,:device_type,:string
	add_column :tracker_visits,:postal_code,:string
	add_column :tracker_visits,:utm_content,:string
	add_column :tracker_visits,:landing_page,:string
	add_column :tracker_visits,:screen_width,:string
	add_column :tracker_visits,:utm_campaign,:string
	add_column :tracker_visits,:screen_height,:string
	add_column :tracker_visits,:landing_params,:string
	add_column :tracker_visits,:search_keyword,:string
	add_column :tracker_visits,:referring_domain,:string
        add_column :tracker_visits,:browser_version,:string
  end
end
