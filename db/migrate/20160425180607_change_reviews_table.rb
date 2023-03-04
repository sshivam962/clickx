class ChangeReviewsTable < ActiveRecord::Migration[4.2]
  def up
    add_column :reviews, :review_id, :string
    add_column :reviews, :report_id, :string
    add_column :reviews, :directory, :string
    add_column :reviews, :timestamp, :datetime
    add_column :reviews, :source_link, :string
    add_column :reviews, :title, :string
    add_column :reviews, :author, :string
    add_column :reviews, :text, :text
    add_column :reviews, :link, :string
    add_column :reviews, :source, :string
    add_column :reviews, :url, :string
    add_column :reviews, :name, :string

    Review.all.each do |r|
      r.text = r.content
      r.name = 'Clickx'
      r.directory = 'clickx'
      r.timestamp = r.created_at
      r.save
    end

    remove_column :reviews, :content
  end

  def down
    add_column :reviews, :content, :text

    Review.all.each do |r|
      r.content = r.text
      r.save
    end

    remove_column :reviews, :review_id
    remove_column :reviews, :report_id
    remove_column :reviews, :directory
    remove_column :reviews, :timestamp
    remove_column :reviews, :source_link
    remove_column :reviews, :title
    remove_column :reviews, :author
    remove_column :reviews, :text
    remove_column :reviews, :link
    remove_column :reviews, :source
    remove_column :reviews, :url
    remove_column :reviews, :name
  end
end
