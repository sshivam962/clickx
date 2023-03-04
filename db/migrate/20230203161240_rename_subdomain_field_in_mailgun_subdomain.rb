class RenameSubdomainFieldInMailgunSubdomain < ActiveRecord::Migration[5.2]
  def change
    rename_column :mailgun_subdomains, :sub_domain, :subdomain
  end
end
