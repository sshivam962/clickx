# frozen_string_literal: true

namespace :admin_reports do
  def build_adwords_csv(biz, data, path)
    CSV.open(path, 'w+b') do |file|
      file << ['Search Term', 'Match Type', 'Campaign', 'Ad Group Name',
               'Clicks', 'Impressions', 'Avg. Cost', 'CTR', 'Conversions',
               'Cost']
      CSV.parse(data).drop(2).each do |row|
        next unless row[0] != 'Total'
        cost = biz.adword_cost_markup.blank? ? row[6].to_i :  (row[6].to_i + ((row[6].to_i / 100) * biz.adword_cost_markup))
        file << [row[0], row[1], row[2], row[3], row[4].to_i, row[5].to_i,
                 "$#{(row[7].split(' ')[0].to_f / 1_000_000).round(2)} per click",
                 row[8], row[9], (cost.to_f / 1_000_000).round(2)]
      end
    end
  end

  def send_out_adwords_email(start_date, end_date, type)
    businesses = Business.managing_ppc_service.search_adwords_enabled
    auth_error_accounts = []
    businesses.each do |biz|
      next if biz.adword_campaign_ids.blank?

      data = Adwords.get_csv_data_adwords_queries(
        biz,
        biz.adword_client_id,
        biz.adword_campaign_ids,
        start_date,
        end_date
      )

      next if data.blank?
      path = "#{Rails.root}/tmp/#{biz.name}_#{Date.current.strftime('%Y%m%d')}.csv"
      build_adwords_csv(biz, data, path)

      Notifier.adword_query_email(biz.id, path).deliver_now
    rescue StandardError => e
      if auth_error?(e)
        auth_error_accounts << biz.name
      else
        ErrorNotify.adwords_task(biz, e.message).deliver_later
      end
    end

    if auth_error_accounts.present?
      ErrorNotify.adwords_auth_error(auth_error_accounts).deliver_later
    end
  end

  def auth_error?(error)
    return true if error.message.eql?('OAuth2 token provided must be a Hash')
    return true if error.class == AdsCommon::Errors::AuthError
    return true if error.respond_to?(:type) && error.type.include?('AuthorizationError')

    false
  end

  desc 'Adwords daily email'
  task adwords_daily: :environment do
    if Time.current.monday?
      end_date = Date.current.strftime('%Y-%m-%d')
      start_date = (Date.current - 1.day).strftime('%Y-%m-%d')

      send_out_adwords_email(start_date, end_date, 'daily')
    end
  end

  desc 'Adwords email to Admin'
  task adwords_email_to_admin: :environment do
    if Time.current.friday?
      end_date = Date.current.strftime('%Y-%m-%d')
      start_date = (Date.current - 7.days).strftime('%Y-%m-%d')

      send_out_adwords_email(start_date, end_date, 'weekly')
    end
  end

  desc 'Inactive Free Clients List'
  task inactive_free_accounts: :environment do
    if Time.current.friday?
      @businesses = Business.free.includes(:users).where(users: { invitation_accepted_at: nil, preview_user: false })
      inactive_accounts = []
      @businesses.each do |biz|
        user = biz.users.normal.first
        inactive_accounts << {
          biz_name: biz.name,
          user_name: user.name,
          user_email: user.email,
          created_at: biz.created_at.strftime('%m/%d/%Y')
        }
      end

      AdminMailer.inactive_free_clients_list(inactive_accounts).deliver_now if inactive_accounts.present?
    end
  end

  desc 'Client Lists'
  task client_lists: :environment do
    if Time.current.friday?
      AdminMailer.trial_users_list.deliver_now
      AdminMailer.non_service_clients_list.deliver_now
      AdminMailer.clients_list.deliver_now
    end
  end

  desc 'Send Account Costs Email'
  task agency_billing: :environment do
    date = Date.current
    next if date != date.beginning_of_month

    one_ims_businesses = Agency.oneims.businesses.with_deleted.active_last_month
    billing_details = {
      OneIMS: { count: one_ims_businesses.size,
                amount: one_ims_businesses.size * 50 }
    }

    AdminMailer.account_costs(billing_details, date).deliver_now
  end
end
