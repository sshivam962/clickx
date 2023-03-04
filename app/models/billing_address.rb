class BillingAddress < Address
  belongs_to :billing_addressable, polymorphic: true,
    foreign_type: :addressable_type, foreign_key: :addressable_id
end
