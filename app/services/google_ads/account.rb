class GoogleAds::Account < GoogleAds::Base
  def fetch
    response = send_query(query)
    customer = response.first.customer

    {
      id: customer.id,
      name: customer.descriptive_name
    }
  end

  private

  def query
    <<~QUERY
      SELECT
        customer.id,
        customer.descriptive_name
      FROM customer
      LIMIT 1
    QUERY
  end
end
