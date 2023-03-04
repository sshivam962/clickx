class AddReusableLinkToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :reusable_link, :boolean, default: false
  end
end
