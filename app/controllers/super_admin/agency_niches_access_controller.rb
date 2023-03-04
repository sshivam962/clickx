# frozen_string_literal: true

class SuperAdmin::AgencyNichesAccessController < ApplicationController
  layout 'base'
  before_action :set_agency

  def niches_access
    @agency_niches_full_access = @agency.agency_niches_accesses.where(full_access: true)
  end

  def niches_list
    @industries = Industry.order(title: :asc)
    @agency_niche_access = @agency.agency_niches_accesses.find_by(full_access: false)
  end

  def give_access
    if params[:full_access] == 'true'
      @agency.agency_niches_accesses.find_by(full_access: false).destroy if @agency.agency_niches_accesses.find_by(full_access: false).present?
      @agency_niches_access = @agency.agency_niches_accesses.new(agency_niches_access_params)
      @agency_niches_access.save
    else
      @agency_niches_access = @agency.agency_niches_accesses.find_by(full_access: false)
      if @agency_niches_access.present?
        if params[:industries_ids].nil?
          @agency_niches_access.destroy
        else
          @agency_niches_access.update(industries_ids: params[:industries_ids])
        end
      else
        @agency_niches_access = @agency.agency_niches_accesses.new(agency_niches_access_params)
        @agency_niches_access.industries_ids = params[:industries_ids]
        @agency_niches_access.save
      end
    end
  end

  def cancel_access
    @agency.agency_niches_accesses.find_by(full_access: true).destroy
    redirect_to niches_access_super_admin_agency_niches_access_path(@agency)
  end

  private

  def set_agency
    @agency = Agency.find(params[:id])
  end

  def agency_niches_access_params
    params.permit(:agency_id, :full_access, industries_ids: [])
  end
end
