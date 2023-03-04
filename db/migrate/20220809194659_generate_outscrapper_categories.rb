class GenerateOutscrapperCategories < ActiveRecord::Migration[5.2]
  def up
    # smaller list of categories. will pe populating the complete list later on with admin panel changes
      categories = []
      categories << 'web design company'
      categories << 'web designer'
      categories << 'marketing'
      categories << 'marketing agency'
      categories << 'marketing consultant'
      categories << 'internet marketing service'
      categories.sort!

      categories.each{|cat| Outscrapper::Category.create(category: cat )}

  end

  def down
    Outscrapper::Category.delete_all
  end
end
