# frozen_string_literal: true

module AdminHelper
  def admins_without_calendly_script
    User.admin_users.order(:first_name).where.not(
      id: AdminCalendlyScript.pluck(:user_id)
    ).uniq.map {|user| [user.name, user.id]}
  end
end
