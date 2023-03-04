class RenameAgencySignupLinksToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    rename_table :agency_signup_links, :signup_links
  end
end
