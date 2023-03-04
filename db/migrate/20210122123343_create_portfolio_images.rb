class CreatePortfolioImages < ActiveRecord::Migration[5.1]
  def up
    create_table :portfolio_images do |t|
      t.string :file
      t.references :portfolio, foreign_key: true

      t.timestamps
    end

    Portfolio.find_each do |portfolio|
      next if portfolio.image.blank?

      portfolio.images.create(file: open(portfolio.image.file.url)) rescue nil
    end
  end

  def down
    drop_table :portfolio_images
  end
end
