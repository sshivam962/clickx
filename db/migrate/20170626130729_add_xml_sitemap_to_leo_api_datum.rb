class AddXmlSitemapToLeoApiDatum < ActiveRecord::Migration[4.2]
  def change
    add_column :leo_api_data, :xml_sitemap, :string
  end
end
