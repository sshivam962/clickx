# frozen_string_literal: true

json.lead do
  json.partial! 'leads/shared/lead', lead: @lead
end

