class AddPositionToChapter < ActiveRecord::Migration[5.1]
  def up
    add_column :chapters, :position, :integer

    Course.all.each do |course|
      course.chapters.order(:updated_at).each.with_index(1) do |chapter, index|
        chapter.update_column :position, index
      end
    end
  end

  def down
    remove_column :chapters, :position
  end
end
