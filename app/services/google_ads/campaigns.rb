class GoogleAds::Campaigns < GoogleAds::Base
  def fetch
    response = send_query(query)

    response.map do |row|
      campaign = row.campaign

      {
        id: campaign.id,
        name: campaign.name,
        type: campaign.advertising_channel_type
      }
    end
  end

  private

  def query
    <<~QUERY
      SELECT
        campaign.id,
        campaign.name,
        campaign.advertising_channel_type
      FROM campaign
      WHERE
        campaign.status = ENABLED
      ORDER BY
        campaign.name
    QUERY
  end
end
