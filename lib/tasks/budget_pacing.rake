# frozen_string_literal: true

namespace :budget_pacing do
  def fetch_budget_pacing_report(businesses, type)
    start_date = Date.current.beginning_of_month.strftime('%Y-%m-%d')
    end_date = Date.current.strftime('%Y-%m-%d')
    days_left = (Time.days_in_month Time.current.month) - Time.current.day

    clients = []
    budget_exceeded_clients = []
    businesses.each do |biz|
      @budget = @budget_spend = @budget_left = @to_be_spend = 0

      begin
        if type == 'fb_ads'
          graph = Koala::Facebook::API.new(biz.fb_access_token)
          @campaigns = Facebook::Campaigns::Insights.fetch(graph, biz.fb_ad_account, start_date, end_date)

          @budget = biz.fb_budget
          @budget_spend = @campaigns[:total_spend]
          @budget_left = @budget - @budget_spend
          @to_be_spend = (@budget_left / days_left).round(2)
          @budget_spend = @budget_spend.round(2)
          @budget_left = @budget_left.round(2)
        else
          google_ads_params = {
            current_start_date: start_date,
            current_end_date: end_date
          }
          @adword_data = GoogleAds::Summary.fetch(
            biz, google_ads_params
          )

          @budget = biz.send("#{type}_budget")
          @budget_spend = @adword_data[:total_details][:cost] / 1_000_000
          @budget_left = @budget - @budget_spend
          @to_be_spend = (@budget_left / days_left).round(2)
          @budget_spend = @budget_spend.round(2)
          @budget_left = @budget_left.round(2)
        end
      rescue StandardError => e
        @error = true
        @error_msg = e.message
      end

      client_details = {
        biz_name: biz.name,
        budget: @budget,
        budget_spend: @budget_spend,
        budget_left: @budget_left,
        to_be_spend: @to_be_spend,
        error: @error,
        error_msg: @error_msg
      }

      if @budget_left.negative?
        budget_exceeded_clients << client_details
      else
        clients << client_details
      end
      instance_variables.each { |i| eval("#{i} = nil") }
    end

    [clients, budget_exceeded_clients, days_left]
  end

  desc 'PPC Budget pacing email to users'
  task ppc: :environment do
    next unless Date.current.monday?

    @businesses = Business.managing_ppc_service.search_adwords_enabled
                          .where('ppc_budget > 0')

    client_details, budget_exceeded_clients, days_left =
      fetch_budget_pacing_report(@businesses, 'adword')

    Notifier.budget_pacing_summary_email(client_details, days_left, 'PPC').deliver_now
    Notifier.budget_exceeded_clients_summary(budget_exceeded_clients, days_left, 'PPC').deliver_now
  end

  desc 'Facebook Ads Budget pacing email to users'
  task facebook_ads: :environment do
    next unless Date.current.monday?

    @businesses = Business.managing_ppc_service.facebook_ads_enabled
                          .where('fb_budget > 0')

    client_details, budget_exceeded_clients, days_left =
      fetch_budget_pacing_report(@businesses, 'fb_ads')
    Notifier.budget_pacing_summary_email(client_details, days_left, 'Facebook Ads').deliver_now
    Notifier.budget_exceeded_clients_summary(budget_exceeded_clients, days_left, 'Facebook Ads').deliver_now
  end
end
