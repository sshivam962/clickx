# frozen_string_literal: true

class SyncAgencyToHomeJob < ApplicationJob
  def perform(agency_id)
    @agency = Agency.find agency_id
    sync_agency(build_payload)
  end

  private

  def build_payload
    { agency: extract_agency,  users: extract_users }
  end

  def extract_agency
    @agency.as_json(only: OneIMS::Agency::AVAILABLE_ATTRS)
           .merge(clickx_id: @agency.id)
  end

  def extract_users
    @agency.users.normal.as_json(only: OneIMS::User::AVAILABLE_ATTRS, super: true)
  end

  def sync_agency payload
    OneIMS::Agency.create(payload)
  end
end
