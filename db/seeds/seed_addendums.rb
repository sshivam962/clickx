Agency.all.each do |a|
  Addendum.create(agency_id: a.id)
end
