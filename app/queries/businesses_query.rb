# frozen_string_literal: true

class BusinessesQuery
  attr_reader :relation, :params
  def initialize(relation: Business.all, params: {})
    @relation = relation
    @name = params[:name].presence
    @tags = params[:label].presence
    @services = params[:service].split(',') if params[:service]
    @agency_params = JSON.parse(params[:agency]) if params[:agency].present?
    @page_number = params[:page].presence
  end

  def index_view
    select
    filter
    paginate
    order
    joins
  end

  private

  def select
    @relation = @relation
                .select(:id, :name, :agency_id, :last_logged_in)
                .select('agencies.name as agency__name',
                        'array_agg(tags.name) as label__list')
  end

  def filter
    if empty_filter?
      non_free
    else
      filter_by_name
      filter_by_tags
      filter_by_services
      filter_by_agencies
    end
    relation
  end

  def paginate
    return @relation unless @page_number
    @relation = @relation.paginate(page: @page_number, per_page: 25)
  end

  def order
    @relation = @relation.order(name: :asc)
  end

  def non_free
    return @relation unless empty_filter?
    @relation = @relation.not_free
  end

  def filter_by_name
    return @relation unless @name
    @relation = @relation
                .where('lower(businesses.name) ILIKE :like_name OR businesses.domain ILIKE :like_name OR businesses.unique_id = :name ',
                       name: @name.downcase, like_name: "%#{@name.downcase}%")
  end

  def filter_by_tags
    return @relation unless @tags
    label_set = MultiJson.load(@tags)
    @relation = @relation.tagged_with(label_set['labels'], any: true)
  end

  def filter_by_services
    return @relation unless @services
    service_array = {}
    @services.each { |term| service_array[term] = true }
    @relation = @relation.where(service_array)
  end

  def filter_by_agencies
    return @relation unless @agency_params.present?
    @relation = @relation.joins(:agency).where(agencies: @agency_params)
  end

  def empty_filter?
    !(@name || @tags || @services || @agency_params)
  end

  def joins
    @relation = @relation.joins(:agency)
                         .left_joins(:labels)
                         .group(:id, :name, :agency_id, 'agency__name', :last_logged_in)
  end
end
