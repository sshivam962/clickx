module Public
  class Lead::StrategiesController < PublicController
    layout 'public/lead_strategy'

    before_action :set_lead_strategy, only: %i[show carousel]
    before_action :set_category, only: :default
    before_action :set_lead, only: :default
    before_action :ensure_access

    def show
      @lead = @lead_strategy.lead
    end

    def carousel
      @lead = @lead_strategy.lead
    end

    def default; end

    private

    def set_lead_strategy
      @lead_strategy = ::Lead::Strategy.find(params[:id])
    end

    def set_lead
      @lead = ::Lead.find_by_obfuscated_id(params[:lead_id])
    end

    def ensure_access
      case action_name
      when 'show'
        return if @lead_strategy&.approved?
      when 'carousel'
        return if @lead_strategy&.approved?
      when 'default'
        categories = ::Lead::Strategy::STATIC_CATEGORIES.values
        return if categories.include?(@category) && @lead.present?
      end
      redirect_to ENV['PUBLIC_APP_DOMAIN']
    end

    def set_category
      @category = params[:category]
    end
  end
end
