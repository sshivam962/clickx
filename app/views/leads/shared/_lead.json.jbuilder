# frozen_string_literal: true
json.id             lead['id']
json.first_name     lead['first_name']
json.last_name      lead['last_name']
json.email          lead['email']
json.company        lead['company']
json.domain         lead['domain']
json.phone          lead['phone']
json.value          lead['value']
json.status         lead['status']
json.statuses       Lead::STATUSES
