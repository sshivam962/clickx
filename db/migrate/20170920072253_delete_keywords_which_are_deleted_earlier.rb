class DeleteKeywordsWhichAreDeletedEarlier < ActiveRecord::Migration[4.2]
  def change
    # BusinessKeyword.only_deleted.each do |bk|
    #   keyword = Keyword.find_by(business_id: bk.business_id, id: bk.keyword_id)
    #   next unless keyword
    #   keyword.destroy
    # end
  end
end
