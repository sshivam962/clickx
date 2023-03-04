class CreateCustomPackages < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_packages do |t|
      t.string :name
      t.float :amount
      t.float :implementation_fee
      t.text :description
      t.integer :status, default: 0

      t.string :package_name, null: false

      t.references :agency
      t.references :business

      t.timestamps
    end
  end
end
