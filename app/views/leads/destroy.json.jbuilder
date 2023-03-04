# frozen_string_literal: true

if @lead.errors.blank?
  json.status 200
  json.data nil
  json.message 'Lead Deleted Successfully'
else
  json.status 406
  json.data nil
  json.message @lead.errors.full_messages.first
end
