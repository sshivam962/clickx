class AddVideoEmbedCodeToPortfolio < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :video_embed_code, :text
  end
end
