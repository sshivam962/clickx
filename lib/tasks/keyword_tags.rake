# frozen_string_literal: true

namespace :keywords do
  desc 'Data migration from old keyword tags to new model'
  task initialise_tags: :environment do
    Business.find_each(batch_size: 10) do |business|
      tags = business.owned_tags.where(taggings: { taggable_type: 'Keyword' })
      tags.each do |tag|
        color = TagColor.find_by(tag: tag.name, business_id: business.id).try(:color)
        keyword_tag = business.keyword_tags.create(name: tag.name, color: color)
        keywords = Keyword.tagged_with(tag.name)
        keywords.each do |keyword|
          keyword.keyword_tag = keyword_tag
          keyword.save!
        end
      end
    end
  end
end
