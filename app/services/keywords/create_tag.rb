# frozen_string_literal: true

module Keywords
  class CreateTag
    def initialize(business_id, tags)
      @tags = tags
      @business_id = business_id
    end

    def run
      KeywordTag.transaction do
        @tags.map do |tag|
          KeywordTag.find_or_create_by(tag.merge!(business_id: @business_id))
        end
      end
    end
  end
end
