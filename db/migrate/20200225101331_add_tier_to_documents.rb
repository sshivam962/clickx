class AddTierToDocuments < ActiveRecord::Migration[5.1]
  def up
    add_column :documents, :tier, :integer
    Document.where(free: true).update_all(tier: 'free')
    remove_column :documents, :free
  end

  def down
    add_column :documents, :free, :boolean
    Document.where(tier: 'free').update_all(free: true)
    remove_column :documents, :tier
  end
end
