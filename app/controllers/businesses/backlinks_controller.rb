# frozen_string_literal: true

class Businesses::BacklinksController < BusinessesController
  def ref_domains
    if @business.backlink_service
      backlink_data = Businesses::Backlinks::UpdateRefDomainsUpdatedDate.new(@business).call
      @data = backlink_data.ref_domains
      @ref_domains_data = @data.map { |domain_data| RefDomainsPresenter.new(domain_data) }
      respond_to do |format|
        format.pdf do
          render pdf: "referring_domains.pdf",
                 print_media_type: true
        end
        format.json do
          render json: { status: 200, data: @data } and return
        end
      end
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' }
    end
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching ref domains' } and return
  end

  def anchor_text_page
    if @business.backlink_service
      updated_at = @business.backlink_datum.anchor_text_updated_at
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = get_anchor_text(@business.domain)
          @business.backlink_datum.update_attributes(anchor_text: response,
                                                     anchor_text_updated_at: Time.now)
        end
        @anchor_text = @business.backlink_datum.anchor_text.map { |anchor_text| AnchorTextPresenter.new(anchor_text) }
        respond_to do |format|
          format.pdf do
            render pdf: "anchor_text_page.pdf",
                   print_media_type: true
          end
          format.json do
            render json: { status: 200, data: @business.backlink_datum.anchor_text,
                           errors: 'Error in fetching anchor text.' } and return
          end
        end
      rescue StandardError
        render json: { status: 406, business: @business,
                       errors: 'Error in fetching anchor text pages.' } and return
      end
    end
  end

  def top_pages
    if @business.backlink_service
      updated_at = @business.backlink_datum.pages_updated_at
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = Majestic.get_top_pages(@business.domain)
          @business.backlink_datum.update_attributes(pages: response,
                                                     pages_updated_at: Time.now)
        end
        @pages = @business.backlink_datum.pages.map { |pages| TopPagesPresenter.new(pages) }
        respond_to do |format|
          format.pdf do
            render pdf: "top_pages.pdf",
                   print_media_type: true
          end
          format.json do
            render json: { status: 200, data: @business.backlink_datum.pages } and return
          end
        end
      rescue StandardError
        render json: { status: 406, business: @business,
                       errors: 'Error in fetching top pages.' } and return
      end
    end
  end

  def topics
    @business.backlink_datum = Businesses::Backlinks::UpdateTopicsUpdatedDate.new(@business).call
    @data   = @business.backlink_datum.topics
    @topics = @data.map { |topics| BacklinksTopicsPresenter.new(topics) }
    respond_to do |format|
      format.pdf do
        render pdf: "topics.pdf",
               print_media_type: true
      end
      format.json do
        render json: { status: 200, data: @data } and return
      end
    end
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching topics.' } and return
  end
end
