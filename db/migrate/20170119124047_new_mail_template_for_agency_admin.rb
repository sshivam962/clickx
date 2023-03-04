class NewMailTemplateForAgencyAdmin < ActiveRecord::Migration[4.2]
  def up
     MailTemplate.create(user:User.first,
                         subject: "Invitation to agency",
                         paragraph1: "Welcome to Agency",
                         mail_type: MailTemplate::Types[4])
  end

  def down
    MailTemplate.where(mail_type: MailTemplate::Types[4]).destroy_all
  end
end
