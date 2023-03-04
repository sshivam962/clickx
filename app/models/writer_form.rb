# frozen_string_literal: true

class WriterForm < ApplicationRecord
  def self.data
    WriterForm.first
  end

  def self.weekly_update
    writer_form = WriterForm.new
    writer_form.update_attributes(industry: WriterAccess.list_categories,
                                  product_type: WriterAccess.list_asset_types,
                                  specialty: WriterAccess.list_expertises)
    WriterForm.first.destroy
  end

  def writers_levels
    nums = %w{zero one two three four five six seven eight nine}
    data = WriterForm.data

    (2..6).map do |i|
      {
        stars: i,
        "#{nums[i]}_star_writer" => data.send("#{nums[i]}_star_writer"),
        key: "#{nums[i]}_star_writer"
      }
    end
  end
end
