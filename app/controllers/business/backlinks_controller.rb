class Business::BacklinksController < Business::BaseController
  include Majestic

  def index
    @backlinks = backlinks_summary
    @backlinks_history = backlinks_history
    @new_backlinks = filter_new_backlinks(@backlinks_history)
    @lost_backlinks = filter_lost_backlinks(@backlinks_history)
    @rainfall_backlinks = generate_rainfall(@backlinks_history)

    @cloud_text = anchor_text_word_cloud
    @word_cloud = generate_wordcloud(@cloud_text)
  end

  def all
    order_by = params[:order_by] || 'AnchorText'

    @backlinks = backlinks(order_by).paginate(page: params[:page], per_page: 25)
  end

  def anchor_text
    order_by = params[:order_by] || 'AnchorText'

    @anchor_text_pages = get_anchor_text_pages(order_by).paginate(page: params[:page], per_page: 25)
  end

  def topics
    order_by = params[:order_by] || 'Topic'

    @topics = get_topics(order_by).paginate(page: params[:page], per_page: 25)
  end

  def pages
    order_by = params[:order_by] || 'URL'

    @pages = get_top_pages(order_by).paginate(page: params[:page], per_page: 25)
  end

  def referring_domains
    order_by = params[:order_by] || 'Domain'

    @domains = get_ref_domains(order_by).paginate(page: params[:page], per_page: 25)

  end

  private

  def backlinks(order_by)
    if current_business.backlink_service
      updated_at = current_business.backlink_datum.backlinks_updated_at
      if updated_at.blank? || updated_at < 7.days.ago
        response = get_backlinks(current_business.domain)
        current_business.backlink_datum.update_attributes(
          backlinks: response,
          backlinks_updated_at: Time.current
        )
      end

      @backlinks_sorted = sort_data(
        current_business.backlink_datum.backlinks, order_by
      )

      @backlinks_sorted.map { |backlinks| BacklinksPresenter.new(backlinks) }
    else
      'Business not yet opted for backlinks.'
    end
  rescue StandardError
    'Error in fetching backlinks.'
  end

  def backlinks_summary
    if current_business.backlink_service
      updated_at = current_business.backlink_datum.summary_updated_at if current_business.backlink_datum
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = get_backlink_summary(current_business.domain)
          current_business.backlink_datum.update_attributes(
            summary: response,
            summary_updated_at: Time.now
          )
        end
      rescue StandardError
        'Error in fetching backlinks summary.'
      end
      current_business.backlink_datum.summary
    end
  end

  def anchor_text_word_cloud
    if current_business.backlink_service
      updated_at = current_business.backlink_datum.anchor_word_cloud_updated_at
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = get_word_cloud_data(current_business.domain)
          current_business.backlink_datum.update_attributes(
            anchor_word_cloud: response,
            anchor_word_cloud_updated_at: Time.now
          )
        end
      rescue StandardError
        'Error in fetching backlinks summary.'
      end
      current_business.backlink_datum.anchor_word_cloud
    end
  end

  def get_anchor_text_pages(order_by)
    if current_business.backlink_service
      updated_at = current_business.backlink_datum.anchor_text_updated_at
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = get_anchor_text(current_business.domain)
          current_business.backlink_datum.update_attributes(
            anchor_text: response,
            anchor_text_updated_at: Time.now
          )
        end

        @backlinks_sorted = sort_data(
          current_business.backlink_datum.anchor_text, order_by
        )

        @backlinks_sorted.map { |anchor_text| AnchorTextPresenter.new(anchor_text) }
      rescue StandardError
        'Error in fetching anchor text pages.'
      end
    end
  end

  def backlinks_history
    if current_business.backlink_service
      current_business.backlink_histories
        .select(:tracked_date, :gained, :lost, :business_id)
        .order(:tracked_date)
    else
      'Business not yet opted for backlinks.'
    end
  rescue StandardError
    'Error in fetching backlinks.'
  end

  def get_topics(order_by)
    current_business.backlink_datum = Businesses::Backlinks::UpdateTopicsUpdatedDate.new(current_business).call
    @backlinks_sorted = sort_data(current_business.backlink_datum.topics, order_by)

    @backlinks_sorted.map { |topics| BacklinksTopicsPresenter.new(topics) }
  rescue StandardError
    'Error in fetching topics.'
  end

  def get_top_pages(order_by)
    if current_business.backlink_service
      updated_at = current_business.backlink_datum.pages_updated_at
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = Majestic.get_top_pages(current_business.domain)
          current_business.backlink_datum.update_attributes(
            pages: response,
            pages_updated_at: Time.current
          )
        end

        @backlinks_sorted = sort_data(
          current_business.backlink_datum.pages, order_by
        )

        @backlinks_sorted.map { |pages| TopPagesPresenter.new(pages) }
      rescue StandardError
        'Error in fetching top pages.'
      end
    end
  end

  def get_ref_domains(order_by)
    if current_business.backlink_service
      backlink_data = Businesses::Backlinks::UpdateRefDomainsUpdatedDate.new(current_business).call
      @backlinks_sorted = sort_data(backlink_data.ref_domains, order_by)

      @backlinks_sorted.map do |domain_data|
        RefDomainsPresenter.new(domain_data)
      end
    else
      'Business not yet opted for backlinks.'
    end
  rescue StandardError
    'Error in fetching ref domains.'
  end

  def sort_data(data, order_by)
    int_fields = ['TopicalTrustFlow_Value_0', 'ExtBackLinks', 'TrustFlow', 'CitationFlow', 'RefDomains', 'CitationFlow', 'TopicalTrustFlow', 'Links', 'LinksFromRefDomains', 'TotalLinks', 'DeletedLinks', 'NoFollowLinks', 'EstimatedLinkTrustFlow', 'EstimatedLinkCitationFlow', 'SourceTrustFlow', 'SourceCitationFlow']
    date_fields = ['Date', 'LastSeenDate']
    order = params[:order] || 'ASC'

    sorted_data = data.sort_by do |k, v|
      if int_fields.include?(order_by)
        k[order_by].to_i
      elsif date_fields.include?(order_by)
        k[order_by].to_date
      else
        k[order_by]
      end
    end
    sorted_data = sorted_data.reverse if order.eql?('DESC')

    sorted_data
  end

  def filter_new_backlinks(backlinks)
    backlinks.map { |link| [link.tracked_date.to_datetime.strftime("%Q").to_i, link.gained] }
  end

  def filter_lost_backlinks(backlinks)
    backlinks.map { |link| [link.tracked_date.to_datetime.strftime("%Q").to_i, link.lost] }
  end

  def generate_rainfall(backlinks)
    data_arr = []
    backlinks.map do |link|
      r_val = data_arr.length > 0 ? data_arr[data_arr.length - 1][1] : 0
      data_arr.push([link.tracked_date.to_datetime.strftime("%Q").to_i, r_val + link.gained])
    end
    data_arr
  end

  def generate_wordcloud(cloud_text)
    cloud_text.map { |k, v| { text: k, weight: v } }
  end
end
