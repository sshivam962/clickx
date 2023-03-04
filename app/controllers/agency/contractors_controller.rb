class Agency::ContractorsController < Agency::BaseController
  include AgencyStripeManager

  before_action :set_stripe_customer, only: %i[checkout payment]
  before_action :set_proposal, only: %i[checkout payment create_card]

  def index
    @accepted_projects =
      current_agency.projects.accepted.includes(:accepted_proposal)
  end

  def checkout
    @contractor_stripe_account = Stripe::Account.retrieve(@proposal.user.stripe_user_id)
    if @customer && !@customer.deleted?
      @cards =
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
    end
  end

  def new_card
    content =
      render_to_string partial: '/agency/contractors/new_card',
      locals: {
        proposal: @proposal
      }
    render json: {data: content, status: 200}
  end

  def create_card
    set_customer
    @card = Stripe::Customer.create_source(
      @customer.id,
      { source: params[:token] },
    )
    payment
  end

  def payment
    @charge = Stripe::Charge.create({
      amount: (@proposal.total_amount.to_f * 100).to_i,
      currency: 'usd',
      customer: @customer.id,
      source: params[:card_id].presence || @card.id,
      description: "Agency-#{current_agency.name} | Project-#{@proposal.project.title.titleize}",
      transfer_data: {
        destination: @proposal.user.stripe_user_id,
        amount: (@proposal.amount.to_f * 100).to_i
      }
    })
    @proposal.update(paid: true)
  end

  private

  def set_stripe_customer
    @customer = current_agency.stripe_customer if current_agency.customer_id
  end

  def set_proposal
    @proposal = ProjectProposal.find(params[:proposal_id])
  end
end
