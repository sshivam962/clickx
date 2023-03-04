class Public::SendgridEventsController  < PublicController
  # skip_before_action :verify_authenticity_token

  def callback
    SendgridWebHookJob.perform_async(event_params)
    head :ok
  end

  private

  def event_params
    dataset =[]
    params[:_json].each do |data|
      dataset <<
      {
        id: data['sent_email_id'] ,
        email: data['email'],
        timestamp: data['timestamp'],
        'smtp-id': data['smtp-id'],
        event: data['event'],
        category: data['category'],
        sg_event_id: data['sg_event_id'],
        sg_message_id: data['sg_message_id']
      }
    end
    dataset
  end
end
