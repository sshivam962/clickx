class AddDiscountByToSignupLink < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :discount_by, :float, default: 500
  end
end
