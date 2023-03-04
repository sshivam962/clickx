class AddCityToDomainContact < ActiveRecord::Migration[5.2]
  def change
    add_column :domain_contacts, :city, :string
  end
end
