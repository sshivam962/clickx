# frozen_string_literal: true

if @lead.errors.blank?
  json.status 200
  json.lead do
    json.partial! 'leads/shared/lead', lead: @lead
  end
  json.message 'Lead Created Successfully'
else
  json.status 406
  json.lead nil
  json.message @lead.errors.full_messages.first
end
