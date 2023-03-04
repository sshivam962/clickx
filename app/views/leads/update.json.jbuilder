# frozen_string_literal: true

if @lead.errors.blank?
  json.status 200
  json.lead do
    json.partial! 'leads/shared/lead', lead: @lead
  end
  json.message 'Lead Updated Successfully'
else
  json.status 406
  json.lead do
    json.partial! 'leads/shared/lead', lead: @lead
  end
  json.message @lead.errors.full_messages.first
end
