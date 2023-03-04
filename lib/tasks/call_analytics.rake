# frozen_string_literal: true

namespace :call_analytics do
  require 'marchex'

  desc 'Call Summary'
  task summary: :environment do
    if Date.current.day.eql?(1)
      start_time = Date.current.last_month.beginning_of_month
      end_time = Date.current.last_month.end_of_month
      params = { extended: true, start: start_time.to_s, end: end_time.to_s }

      businesses = Business.where(call_analytics_service: true)

      biz_statuses = {}
      businesses.each { |b| biz_statuses[b.id] = { name: b.name } }

      businesses.each do |biz|
        if biz.call_analytics_service?
          begin
            data = Marchex.call_marchex_api([biz.call_analytics_id, params],
                                            'call.search')

            call_duration = data.map { |x| x['call_duration'] || 0 }.sum
            biz_statuses[biz.id][:info] = (call_duration / 60.0).ceil
          rescue StandardError
            biz_statuses[biz.id][:info] = 'Error in fetching call analytics'
          end
        else
          biz_statuses[biz.id][:info] = '-'
        end
      end
      biz_statuses = biz_statuses.sort_by { |_k, v| v[:info] }.reverse.to_h
      Notifier.marchex_monthly_summary(biz_statuses, start_time, end_time)
              .deliver_now
    end
  end

  desc 'Update daily marchex cache for all businesses'
  task update_marchex_cache: :environment do
    Business.where.not(call_analytics_id: nil).find_each do |business|
      Rails.cache.fetch("marchex_calls_#{business.id}_#{Date.current}_#{Date.current - 1.month}", expires_in: 24.hours) do
        Marchex.calls(
          start_date: Date.current.to_s,
          end_date: (Date.current - 1.month).to_s,
          call_analytics_id: business.call_analytics_id
        )
      rescue Marchex::Error => e
        Rails.logger.info "Failed to update cache for  #{business.name} #{e.message}"
      end
    end
  end
end
