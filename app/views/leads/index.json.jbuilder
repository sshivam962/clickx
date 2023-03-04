# frozen_string_literal: true

json.leads do
  json.array!(@leads) do |lead|
    json.partial! 'leads/shared/lead', lead: lead
  end
end
