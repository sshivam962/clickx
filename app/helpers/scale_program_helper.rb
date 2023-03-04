# frozen_string_literal: true

module ScaleProgramHelper
  def main_title week
    "Pillar #{week.to_words.titleize} #{sub_title week}"
  end  

  def sub_title week
    case week
    when 1
      ': FOUNDATIONS & KILLER OFFER DEVELOPMENT'
    when 2
      ': ORGANIC LEAD GEN & SALES MASTERY'
    when 3  
      ': SCALING WITH ADS & FUNNELS'
    else
      ''
    end
  end  
end