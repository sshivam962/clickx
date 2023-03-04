class Address < ApplicationRecord
  def name
    [first_name, last_name].join(' ')
  end

  def full_address
    [
      address_line_1,
      address_line_2,
      city,
      state,
      country
    ].compact.join(', ')
  end
end
