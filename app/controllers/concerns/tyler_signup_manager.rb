module TylerSignupManager
  extend ActiveSupport::Concern

  included do
    private

    def tyler_signup
      add_labels
      add_packages
      enable_white_labeld
      enable_case_study
      add_level
      save_agency
      subscribe_plan
      add_courses
    end

    def subscribe_plan
      ActiveRecord::Base.transaction do
        plan = Package.growth.plans.find_by(key: 'starter')
        @agency.package_subscriptions.create(
          amount: plan.amount,
          billing_category: plan.billing_category,
          package_name: plan.package_name,
          package_type: plan.package_type,
          billing_type: :manual,
          status: 'active'
        )
      end
    end

    def add_packages
      @agency.enabled_packages = Package::TYLER_CLIENT_PACKAGES
    end

    def add_labels
      @agency.labels = 'DFYElite'
    end

    def add_courses
      @agency.courses =
        Course.agency.where(
          title: [
            'Clickx 101', 'Industry Specific Campaigns', 'Our Processes',
            'Strategy + Recommendations', 'White Glove Onboarding', 'Our Products'
          ]
        )
    end

    def enable_white_labeld
      @agency.white_labeled = true
    end

    def enable_case_study
      @agency.case_study_enabled = true
    end

    def add_level
      @agency.level = 'silver'
    end
  end
end
