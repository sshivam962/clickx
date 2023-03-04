class MoveKeywordTagDataToTaggable < ActiveRecord::Migration[5.1]
  def change
    Keyword.where.not(keyword_tag_id: nil).find_each do |keyword|
      Taggable.create(keyword_id: keyword.id, keyword_tag_id: keyword.keyword_tag_id)
    end
  end
end
