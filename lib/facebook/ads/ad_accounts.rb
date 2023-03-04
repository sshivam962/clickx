# frozen_string_literal: true

module Facebook::Ads
  class AdAccounts
    attr_reader :graph

    def self.fetch(graph)
      new(graph).fetch
    end

    def initialize(graph)
      @graph = graph
    end

    def fetch
      ad_accounts
    rescue StandardError => e
      e.message
    end

    private

    def ad_accounts
      ad_accounts = graph.get_connections('me', 'adaccounts', fields: 'name')
      ad_accounts_array = ad_accounts.to_a
      while (ad_accounts = ad_accounts.next_page)
        ad_accounts_array += ad_accounts
      end
      ad_accounts_array.sort_by{ |acc| acc['name'] }
    rescue Koala::Facebook::ClientError => e
      raise e.message
    end
  end
end
