class AddNameSlugToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :name_slug, :string

    Agency.find_each do |agency|
      agency.update(name_slug: agency.name.parameterize)
    end
  end
end
