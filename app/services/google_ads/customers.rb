class GoogleAds::Customers
  def self.fetch(business)
    token = business.tokens.find_by(code_type: Token::GoogleAdsToken)
    client = GoogleAds.new(token: token).client

    customer_ids = []
    all_customers = []

    customer_names = client.service.customer.list_accessible_customers().resource_names
    customer_names.each do |res|
      customer_ids << res.split('/')[1]
    end

    customer_ids.each do |cid|
      # Performs a breadth-first search to build a dictionary that maps managers
      # to their child accounts (cid_to_children).
      unprocessed_customer_ids = Queue.new
      unprocessed_customer_ids << cid
      cid_to_children = Hash.new { |h, k| h[k] = [] }

      query = <<~QUERY
        SELECT
          customer_client.client_customer,
          customer_client.level,
          customer_client.hidden,
          customer_client.test_account,
          customer_client.manager,
          customer_client.descriptive_name,
          customer_client.id
        FROM customer_client
        WHERE
          customer_client.level <= 1
          AND customer_client.test_account = false
          AND customer_client.hidden = false
      QUERY
      client = GoogleAds.new(token: token, customer_id: cid).client
      ads_service = client.service.google_ads

      while unprocessed_customer_ids.size > 0
        cid = unprocessed_customer_ids.pop

        begin
          response = ads_service.search(
            customer_id: cid,
            query: query,
            page_size: 1000,
          )
        rescue Google::Ads::GoogleAds::Errors::GoogleAdsError => e
          Rails.logger.error "***********  GoogleAdsError: ***********"
          Rails.logger.error(e.failure.errors.map(&:message).to_sentence)
          Rails.logger.error "***********  GoogleAdsError: ***********"

          next
        end

        # Iterates over all rows in all pages to get all customer clients under
        # the specified customer's hierarchy.
        response.each do |row|
          customer_client = row.customer_client

          all_customers << {
            id: customer_client.id,
            mid: cid,
            level: customer_client.level,
            hidden: customer_client.hidden,
            test_account: customer_client.test_account,
            name: customer_client.descriptive_name,
            status: customer_client.status,
          }

          # The customer client that with level 0 is the specified customer
          next if customer_client.level == 0

          # For all level-1 (direct child) accounts that are a manager account,
          # the above query will be run against them to create a dictionary of
          # managers mapped to their child accounts for printing the hierarchy
          # afterwards.
          cid_to_children[cid.to_s] << customer_client

          if customer_client.manager && customer_client.level == 1
            if !cid_to_children.key?(customer_client.id.to_s) &&
              unprocessed_customer_ids << customer_client.id.to_s
            end
          end
        end
      end
    end

    all_customers
  end
end
