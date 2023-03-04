module Agency::LeadSourcesHelper
  
  def options_for_state
    CS.states(:us).invert
  end

  def options_for_city(states)
    cities = {}
    country = ISO3166::Country.new("US")
    states.each do |state|
    label_state = country.states.values.find{|x| x.code.downcase == state.downcase}.name
    cities[label_state] = CS.get(:us, state)
    end
    cities
  end

  def get_previous_categories(lead_source_id)
    last_request = get_last_request(lead_source_id)
    last_request.nil? ? [] : Outscrapper::Category.where(category: last_request.categories)
  end

  def get_selected_categories(lead_source_id)
    last_request = get_last_request(lead_source_id)
    last_request.nil? ? [] : last_request.categories
  end

  def get_previous_cities(lead_source_id)
    last_request = get_last_request(lead_source_id)
    last_request.nil? ? [] : last_request.cities.nil? ? [] : last_request.cities
  end

  def get_selected_state(lead_source_id)
    last_request = get_last_request(lead_source_id)
    last_request.nil? ? [] : last_request.states
  end

  def get_selected_zips(lead_source_id)
    last_request = get_last_request(lead_source_id)
    last_request.nil? ? [] : last_request.zip_codes
  end

  private

  def get_last_request(lead_source_id)
    current_agency.outscrapper_requests.where(lead_source_id: lead_source_id).last
  end

end
