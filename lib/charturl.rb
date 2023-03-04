# frozen_string_literal: true

module Charturl
  def charturl_url(chart_type, options)
    case chart_type
    when 'pie'
      <<~URL
        https://quickchart.io/chart/render/zm-50dd7229-88e2-4900-b60c-3f836c5d611d?data1=#{options.values.join(',')}
      URL
    end.strip
  end
end
