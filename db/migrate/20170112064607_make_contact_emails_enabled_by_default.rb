class MakeContactEmailsEnabledByDefault < ActiveRecord::Migration[4.2]
  def up
    User.business_users_mailing_list.collect(&:init_email_settings)
  end
end
