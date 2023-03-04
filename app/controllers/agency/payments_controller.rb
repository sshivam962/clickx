class Agency::PaymentsController < Agency::BaseController

  def index
    @payments = Payment.where(agency_id: current_agency.id).where.not(metadata: nil).order(created_at: :desc)
  end
end
