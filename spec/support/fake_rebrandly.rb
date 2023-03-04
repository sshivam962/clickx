# frozen_string_literal: true

# In test environment, intercept calls to rebrandly API and just return the
# original URL.

module Rebrandly
  def self.shorten(destination, _options = {})
    destination
  end
end
