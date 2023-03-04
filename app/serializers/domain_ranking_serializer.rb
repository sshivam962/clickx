# frozen_string_literal: true
class DomainRankingSerializer < ActiveModel::Serializer
  SERPURL = 'https://www.google.com/search?gws_rd=ssl,cr&pws=0&uule=w+CAIQICISQ2hnbywgSWxsaW5vaXMsIFVT&num=100&q='

  attributes :rank, :keyword_name, :googleSerpUrl

  def googleSerpUrl
    SERPURL + object[:keyword_name].tr(' ', '+')
  end
end
