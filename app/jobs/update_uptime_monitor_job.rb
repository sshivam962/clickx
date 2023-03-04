# frozen_string_literal: true

class UpdateUptimeMonitorJob < ApplicationJob
  def perform(business)
    ActiveRecord::Base.connection_pool.with_connection do
      monitor_id = business.monitor_id
      if business.managed_service? && monitor_id.blank?
        resp = UptimeRobot.create_monitor(business.name, business.domain)
        if resp['stat'] == 'ok'
          business.update_columns(monitor_id: resp['monitor']['id'])
        end
      elsif monitor_id.present?
        UptimeRobot.delete_monitor monitor_id
        business.update_columns(monitor_id: nil)
      end
    end
  end
end
