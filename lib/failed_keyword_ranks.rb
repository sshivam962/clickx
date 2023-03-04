# frozen_string_literal: true
module FailedKeywordRanks
  def self.get_failed_rank(engine: 'google', date: Time.zone.today)
    query = %{
    SELECT keywords.name,
    keywords.city,
    businesses.name as biz_name,
    businesses.id as biz_id,
    businesses.locale as locale
    FROM keywords, businesses
    WHERE keywords.business_id = businesses.id
    AND keywords.type in ('Keyword')
    AND keywords.deleted_at IS NULL
    AND keywords.id NOT IN (
              SELECT keyword_id
              FROM keyword_rankings
              WHERE #{engine}_callback_updated_at::date='#{date}'::date)}
    ActiveRecord::Base.connection.execute(query)
  end
end
