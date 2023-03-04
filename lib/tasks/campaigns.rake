# frozen_string_literal: true

namespace :campaigns do
  desc 'Update campaign ids for automated businesses'
  task update_campaign_ids: :environment do
    adword_types = {
      'Search' => 'adword'
    }

    adword_types.each do |k, v|
      businesses = Business.where.not("#{v}_client_id": [nil, '']).where("automate_#{v}_campaign": true)
      businesses.each do |biz|
        adword_data = Adwords::Adword.new(biz, biz.send("#{v}_client_id"), v).campaigns
        next unless adword_data

        campaign_ids = adword_data.select{|d| d[:type] == k}.pluck(:id)
        biz.send(:update, { "#{v}_campaign_ids" => campaign_ids })
      rescue => e
        Rails.logger.info '[Adwords-Sync-E]: =================================='
        Rails.logger.info "[Adwords-Sync-E]: #{k} : #{biz.name} : #{e.message}"
        Rails.logger.info '[Adwords-Sync-E]: =================================='
      end
    end
  end
end
