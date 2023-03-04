class SendgridWebHookJob
  include Sidekiq::Worker

  def perform(params)
    @params = params
    @params.each do |param|
      @sent_email = SentEmail.find_by_id(param['id'])
      next unless @sent_email

      case param['event']
      when 'open'
        update_email_opened_at(@sent_email, param)
      when 'click'
        # TODO : manage click event
        # add_click_event(@sent_email, param)
      end
    end
  end

  private

  def update_email_opened_at(sent_email, param)
    return if sent_email.email_opened_at.present?

    sent_email.update(email_opened_at: Time.at(param['timestamp']))
  end

  # def add_click_event(sent_email, param)
  #   @click =
  #     sent_email.email_click_events.find_by_sg_event_id(param['sg_event_id'])
  #   return if @click.present?

  #   sent_email.email_click_events.create(
  #     clicked_at: Time.at(param['timestamp']),
  #     sg_event_id: param['sg_event_id'],
  #     metadata: param
  #   )
  # end
end
