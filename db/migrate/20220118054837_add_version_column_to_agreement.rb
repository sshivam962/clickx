class AddVersionColumnToAgreement < ActiveRecord::Migration[5.1]
  def change
    add_column :agreements, :version, :string

    Agreement.where(agreementable_type: 'Agency').update_all(version: 'v1')
  end
end
