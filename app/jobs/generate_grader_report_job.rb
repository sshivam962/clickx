# frozen_string_literal: true

class GenerateGraderReportJob
  include Sidekiq::Worker

  def perform(report_id)
    report = GraderReport.find(report_id)
    ActiveRecord::Base.connection_pool.with_connection do
      report.fetch_details
      report.reload.update(status: :completed)
    end
  end
end
