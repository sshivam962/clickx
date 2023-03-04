module States
  extend ActiveSupport::Concern

  included do
    def list
      country = ISO3166::Country.find_country_by_name(params[:country])
      @states = country.states.values.map(&:translations).map{|t| t['en']}
      render json: {
        status: 200,
        content:
          render_to_string(
            partial: states_partial,
            locals: {
              states: @states,
              state: params[:state],
              field_name: params[:field_name]
            }
          )
      }
    end

    private

    def states_partial
      params[:partial].presence || 'shared/states'
    end
  end
end
