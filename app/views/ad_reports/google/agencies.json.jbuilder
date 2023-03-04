# frozen_string_literal: true

json.agencies do
  json.array!(@agencies) do |agency|
    json.id                     agency.id
    json.name                   agency.name
    json.businesses             []
  end
end
