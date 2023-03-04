class AddEmailLogoToAgency < ActiveRecord::Migration[4.2]
  def up
    add_column :agencies, :email_logo, :string

    Agency.all.each do |agency|
      agency.update_attributes(email_logo: agency.logo)
    end
  end

  def down
    remove_column :agencies, :email_logo, :string
  end
end
