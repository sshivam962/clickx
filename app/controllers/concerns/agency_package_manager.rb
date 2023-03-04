module AgencyPackageManager
  extend ActiveSupport::Concern

  included do
    private

    def subscribe_package
      ActiveRecord::Base.transaction do
        cancel_current_subscription
        unless params[:agency][:package].eql?('free')
          @plan = Plan.find params[:agency][:package]
          @agency.package_subscriptions.create(
            amount: @plan.amount,
            billing_category: @plan.billing_category,
            package_name: @plan.package_name,
            package_type: @plan.package_type,
            billing_type: :manual,
            status: 'active'
          )
        end
      end
    end

    def cancel_current_subscription
      @agency.active_package_subscriptions.manual.where(
        package_type: 'agency_infrastructure'
      ).update(status: 'cancelled')
    end
  end
end
