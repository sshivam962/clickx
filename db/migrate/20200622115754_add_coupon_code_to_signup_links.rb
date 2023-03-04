class AddCouponCodeToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :coupon_code, :string
  end
end
