# frozen_string_literal: true

module Facebook::Ads
  class AdPreview
    attr_reader :graph, :creative_id

    def self.fetch(graph, creative_id)
      new(graph, creative_id).fetch
    end

    def initialize(graph, creative_id)
      @graph = graph
      @creative_id = creative_id
    end

    def fetch
      preview
    end

    private

    def preview
      graph.get_object("#{creative_id}/previews?ad_format=DESKTOP_FEED_STANDARD")
    rescue Koala::Facebook::ClientError => e
      { error: e.message.split('message:').last.split(', x-fb-trace-id').first }
    end
  end
end
