class AddCategoryToSignupLinks < ActiveRecord::Migration[5.1]
  def up
    add_column :signup_links, :category, :integer
    SignupLink.update_all category: :agency
  end

  def down
    remove_column :signup_links, :category
  end
end
