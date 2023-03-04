class AddDiscountTypeToSignupLinks < ActiveRecord::Migration[5.1]
  def up
    add_column :signup_links, :discount_type, :integer

    SignupLink.where.not(coupon_code: [nil, '']).update(discount_type: 'coupon')
  end

  def down
    remove_column :signup_links, :discount_type
  end
end
