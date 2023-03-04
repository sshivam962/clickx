# frozen_string_literal: true

class SearchResultPageJob
  include AuthorityLabs
  include Sidekiq::Worker
  sidekiq_options throttle: { threshold: 2000,
                              period: 1.hour,
                              key: 'search_result_page' }

  def perform(params, type, queue_type)
    # TODO: workaround, fix me
    params = eval(params) if params.is_a?(String)
    params = params.with_indifferent_access

    Sidekiq::Client.push(
      'class' => sidekiq_class(type),
      'queue' => sidekiq_queue(queue_type),
      'args' => intial_setup(params)
    )
  end

  private

  def sidekiq_class(type)
    case type
    when 'search_result_ranking'
      FetchSearchResultRankCallbackJob
    else
      FetchRankCallbackJob
    end
  end

  def sidekiq_queue(queue_type)
    case queue_type
    when 'priority'
      'search_results_priority_queue'
    else
      'search_results_delayed_queue'
    end
  end

  def intial_setup(params)
    geo = nil
    if params['geo'].present?
      geo = if params['geo'].class == String
              params['geo']
            else
              params['geo']['geo']
            end
    end

    [params['json_callback'], params['rank_date'], params['keyword'], params['engine'], geo, params['locale'], params]
  end
end
