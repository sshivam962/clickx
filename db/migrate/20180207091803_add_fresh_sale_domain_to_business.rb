class AddFreshSaleDomainToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :fresh_sale_domain, :string
  end
end
