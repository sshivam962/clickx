class CreateAgreements < ActiveRecord::Migration[5.1]
  def change
    create_table :agreements do |t|
      t.boolean :signed
      t.string :file
      t.string :signature

      t.references :agreementable, polymorphic: true
      t.timestamps
    end
  end
end
