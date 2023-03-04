if @agency.errors.blank?
  json.status 200
  json.agency @agency
  json.message 'CNAME Verified Successfully'
else
  json.status 406
  json.agency @agency
  json.message @agency.errors.full_messages.first
end
