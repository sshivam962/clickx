# frozen_string_literal: true

FactoryBot.define do
  # invitation
  factory :mail_template do |mt|
    mt.mail_type      { MailTemplate::Types[0] }
    mt.subject        { MailTemplate::Types[0].titleize }
    mt.welcome_text   do
      '<tr>\n\t<td style=\"color:#f7af30;font-size:28px;line-height:28px;
                       font-weight:bold;padding:20px 0\">\n\t\tYou’re invited xyz,\n\t</td></tr>'
    end
    mt.paragraph1     { '<table border="0" cellpadding="0" cellspacing="0" width="100%"><tbody><tr><td style="font-weight:bold;color:#646464;padding:10px 0">Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</td></tr><tr><td style="color:#646464;padding:10px 0">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</td></tr></tbody></table>' }
  end

  # new customer comment
  factory :new_comment_mail_template, class: MailTemplate do |mt|
    mt.mail_type      { MailTemplate::Types[1] }
    mt.subject        { MailTemplate::Types[1].titleize }
    mt.welcome_text   do
      '<tr>\n\t<td style=\"color:#f7af30;font-size:28px;line-height:28px;
                       font-weight:bold;padding:20px 0\">\n\t\tYou’re invited xyz,\n\t</td></tr>'
    end
    mt.paragraph1     { '<table border="0" cellpadding="0" cellspacing="0" width="100%"><tbody><tr><td style="font-weight:bold;color:#646464;padding:10px 0">Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</td></tr><tr><td style="color:#646464;padding:10px 0">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</td></tr></tbody></table>' }
  end

  # content feedback
  factory :content_feedback_mail_template, class: MailTemplate do |mt|
    mt.mail_type      { MailTemplate::Types[2] }
    mt.subject        { MailTemplate::Types[2].titleize }
    mt.welcome_text   do
      '<tr>\n\t<td style=\"color:#f7af30;font-size:28px;line-height:28px;
                       font-weight:bold;padding:20px 0\">\n\t\tYou’re invited xyz,\n\t</td></tr>'
    end
    mt.paragraph1     { '<table border="0" cellpadding="0" cellspacing="0" width="100%"><tbody><tr><td style="font-weight:bold;color:#646464;padding:10px 0">Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</td></tr><tr><td style="color:#646464;padding:10px 0">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</td></tr></tbody></table>' }
  end

  # new content
  factory :new_content_mail_template, class: MailTemplate do |mt|
    mt.mail_type      { MailTemplate::Types[3] }
    mt.subject        { MailTemplate::Types[3].titleize }
    mt.welcome_text   do
      '<tr>\n\t<td style=\"color:#f7af30;font-size:28px;line-height:28px;
                       font-weight:bold;padding:20px 0\">\n\t\tYou’re invited xyz,\n\t</td></tr>'
    end
    mt.paragraph1 { '<table border="0" cellpadding="0" cellspacing="0" width="100%"><tbody><tr><td style="font-weight:bold;color:#646464;padding:10px 0">Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</td></tr><tr><td style="color:#646464;padding:10px 0">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</td></tr></tbody></table>' }
  end
end
