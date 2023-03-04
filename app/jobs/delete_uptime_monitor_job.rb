# frozen_string_literal: true

class DeleteUptimeMonitorJob < ApplicationJob
  def perform(monitor_id)
    UptimeRobot.delete_monitor monitor_id
  end
end
