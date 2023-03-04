# frozen_string_literal: true

class SuperAdmin::PartnerSearchController < ApplicationController
  layout 'base'
  include SuperAdmin::AgencyFilterManager

  def index
    @filter_query = filter_query
    @agencies =
      Agency.with_deleted.includes(:users, :growth_subscriptions).references(:users).where(@filter_query).reorder(created_at: :desc)
  end
end
