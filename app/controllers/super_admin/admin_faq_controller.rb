class SuperAdmin::AdminFaqController < SuperAdmin::BaseController
  layout 'base'
  before_action :perform_authorization

  def index
    @admin_faqs = AdminFaq.order(position: :asc)
  end

  private

  def perform_authorization
    authorize %i[super_admin admin_faq]
  end

end
