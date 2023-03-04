# frozen_string_literal: true

class AuthorityLabsController < ActionController::Base
  def callback
    if success?
      Sidekiq::Client.push(
        'class' => SearchResultPageJob,
        'queue' => 'search_results_delayed_queue',
        'args' => [permit_params(params), 'keyword_ranking', 'delayed']
      )
    else
      error_logger
    end
    head :ok
  end

  def delayed_keyword_ranking
    if success?
      Sidekiq::Client.push(
        'class' => SearchResultPageJob,
        'queue' => 'search_results_delayed_queue',
        'args' => [permit_params(params), 'keyword_ranking', 'delayed']
      )
    else
      error_logger
    end
    head :ok
  end

  def priority_keyword_ranking
    if success?
      Sidekiq::Client.push(
        'class' => SearchResultPageJob,
        'queue' => 'search_results_priority_queue',
        'args' => [permit_params(params), 'keyword_ranking', 'priority']
      )
    else
      error_logger
    end
    head :ok
  end

  def delayed_search_result_ranking
    if success?
      Sidekiq::Client.push(
        'class' => SearchResultPageJob,
        'queue' => 'search_results_delayed_queue',
        'args' => [permit_params(params), 'search_result_ranking', 'delayed']
      )
    else
      error_logger
    end
    head :ok
  end

  def priority_search_result_ranking
    if success?
      Sidekiq::Client.push(
        'class' => SearchResultPageJob,
        'queue' => 'search_results_priority_queue',
        'args' => [permit_params(params), 'search_result_ranking', 'priority']
      )
    else
      error_logger
    end
    head :ok
  end

  private

  def error_logger
    Rails.logger.info '[ALR-E]: ================================== '
    Rails.logger.info "[ALR-E]: #{params} "
    Rails.logger.info '[ALR-E]: ================================== '
  end

  def permit_params(params)
    params.permit!.to_h.with_indifferent_access
  end

  def success?
    params[:status_code].to_i == 200 && params[:status] == 'success'
  end
end
