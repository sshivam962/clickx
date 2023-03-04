class SuperAdmin::ChatsController < SuperAdmin::BaseController
  before_action :set_thread, only: %i[message_history reply block]
  before_action :set_as_read, only: %i[message_history]
  before_action :message_day_report, only: %i[message_report]

  def index
    @threads =
      Twillio::ChatThread
        .includes(:contact)
        .non_blocked
        .where(search_query)
        .references(:twillio_contacts)
        .order(updated_at: :desc)
        .paginate(page: params[:page].presence || 1, per_page: 15)
  end

  def send_message
    
    @contact = Twillio::Contact.find_or_create_by(phone: params[:phone])
    @contact.update(name: params[:name])
    @chat_thread =
      Twillio::ChatThread.find_or_create_by(contact_phone: params[:phone])
    sms = send_msg(@chat_thread.contact_phone, params[:message])
    if sms
      @chat_thread.add_sms(sms, current_user.id)
      contact_phone = @chat_thread.contact_phone[-10..-1] || @chat_thread.contact_phone
      flash[:notice] = 'Message has been sent successfully'

      Hubspot.configure(
        client_id: ENV['HUBSPOT_CLIENT_ID'],
        client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
        redirect_uri: auth_hubspot_callback_url,
        access_token: HubspotAuth.get_access_token
      )

      contact = Hubspot::Contact.search(contact_phone, options = {count: 1})
      if contact.resources.present?
        note_body = "Outbound SMS: " + params[:message]
        contact_id = contact.resources.first.id
        Hubspot::EngagementNote.create!(contact_id, note_body, owner_id = nil, deal_id = nil)
        
      end
    else
      flash[:error] = 'Unable to send SMS to this number'
    end

    redirect_to action: :index
  end

  def message_history; end

  def message_report; end

  def get_chat_template
    @chat_template = ChatTemplate.find(params[:id])
    render(
        json: {
          code: 200,
          template_data: @chat_template.template_data
        }
      )
  end

  def reply
    if params[:message].present?
      sms = send_msg(@chat_thread.contact_phone, params[:message])
      if sms
        @chat_thread.add_sms(sms, current_user.id)
        contact_phone = @chat_thread.contact_phone[-10..-1] || @chat_thread.contact_phone
        Hubspot.configure(
          client_id: ENV['HUBSPOT_CLIENT_ID'],
          client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
          redirect_uri: auth_hubspot_callback_url,
          access_token: HubspotAuth.get_access_token
        )

        contact = Hubspot::Contact.search(contact_phone, options = {count: 1})
        if contact.resources.present?
          note_body = "Outbound SMS: " + params[:message]
          contact_id = contact.resources.first.id
          Hubspot::EngagementNote.create!(contact_id, note_body, owner_id = nil, deal_id = nil)
          
        end
      else
        flash[:error] = 'Unable to send SMS to this number'
      end
    end
  end

  def import
    Twillio::Contact.import(params[:file])
    redirect_to action: :index
  end

  def block
    @chat_thread.update(blocked: true)
    redirect_to action: :index
  end

  def create_ai_message
    @gpt_prompt = 'Write an icebreaker sentance by below message. '

    @gpt_prompt << params[:message]
    

    client = Openai.authorization_uri
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: @gpt_prompt,
        max_tokens: 1000
    })

    content = []
    if response["choices"].present?
      content = response["choices"].map { |c| c["text"] }
    end
    render json: { status: 200, data: { content: content.to_json } }
  end

  private

  def set_thread
    @chat_thread = Twillio::ChatThread.find params[:id]
  end

  def set_as_read
    @chat_thread.update(unread: false)
  end

  def message_day_report

    if params[:search_date].blank?
      @search_date = Time.now.strftime("%Y-%m-%d")
      @search_start_date = Time.now.strftime("%Y-%m-%d 00:00:00")
      @search_end_date = Time.now.strftime("%Y-%m-%d 23:59:59")
    else
      @search_date = params[:search_date].to_datetime.strftime("%Y-%m-%d")
      @search_start_date = params[:search_date].to_datetime.strftime("%Y-%m-%d 00:00:00")
      @search_end_date = params[:search_date].to_datetime.strftime("%Y-%m-%d 23:59:59")
    end
    @message_report_list = Twillio::Message.where(search_date_query).group(:user_id).count
  end

  def send_msg(number, message)
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: ENV['TWILIO_SUPPORT_NUMBER'],
      to: number,
      body: message
    )
  rescue => e
    Raven.capture_exception(e)
    Rails.logger.debug "=============Error in Twillio API call============"
    Rails.logger.debug "=============Error : #{e.message}============"
  end

  def search_query
    return '' if params[:query].blank?

    "contact_phone ILIKE '%#{params[:query]}%' OR twillio_contacts.name ILIKE '%#{params[:query]}%'"
  end

  def search_date_query
    "('#{@search_start_date}' <= created_at AND created_at < '#{@search_end_date}') AND status = 1"
  end
end
