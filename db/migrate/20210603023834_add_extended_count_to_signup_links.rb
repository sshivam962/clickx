class AddExtendedCountToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :extended_count, :integer, default: 0
  end
end
