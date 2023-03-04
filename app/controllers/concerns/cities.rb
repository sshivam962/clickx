module Cities
  extend ActiveSupport::Concern

  included do
    def list
      country = ISO3166::Country.new("US")
      target_state = params["state"]
      state_code = country.states.values.find{|x| x.name.downcase == target_state.downcase}.code
      cities = CS.get(:us, state_code)
      render json: {
        status: 200,
        content: { cities: cities, state: params["state"] }
      }
    end

  end
end
