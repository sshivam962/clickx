class Agency::CardsController < Agency::BaseController
  include AgencyStripeManager

  skip_before_action :agency_active_check, :active_agency?
  before_action :set_customer, only: %i[create set_default]

  def new
    data = render_to_string(partial: 'agency/cards/shared/new')
    respond_to do |format|
      format.json { render json: { data: {content: data } } }
      format.html
    end
  end

  def create
    card = @customer.sources.create(source: credit_card_attrs)
    @customer.default_source = card.id
    @customer.save
  rescue Exception => e
    @error = e.message
  end

  def index
    @customer = current_agency.stripe_customer
    @cards = []

    if @customer.present?
      @cards =
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
      @default_card = @customer&.default_source
    end
  end

  def set_default
    @customer.default_source = params[:default_card]
    @customer.save
  rescue Exception => e
    @error = e.message
  end
end
