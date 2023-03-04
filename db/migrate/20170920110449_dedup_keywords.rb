class DedupKeywords < ActiveRecord::Migration[4.2]
  def change
    Keyword.group(:city, :business_id, :name)
      .select(:city, :business_id, :name)
      .having("count(*) > 1").each do |duplicate|
      rows = Keyword.where(duplicate.attributes.except('id')).to_a

      rows.shift

      rows.map(&:destroy)
    end

    # add_index :keywords, [:city, :business_id, :name], unique: true
  end
end
