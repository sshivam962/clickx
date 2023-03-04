# frozen_string_literal: true

module IndustryHelper
  def industry_icons_collection
    Industry::ICONS.map do |icon|
      [
        " #{icon.gsub('-', ' ')}",
        "clickx-Industries-#{icon}"
      ]
    end
  end
end
