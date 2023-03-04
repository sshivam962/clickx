class UpdateMinRecommendedPriceForPlans < ActiveRecord::Migration[5.1]
  def up
    Plan.where.not(package_type: %w[ala_carte agency_infrastructure]).each do |plan|
      plan.update(min_recommended_price: plan.amount + 500)
    end

    Plan.where(package_type: 'ala_carte').each do |plan|
      plan.update(min_recommended_price: ala_carte_changes[plan.key.to_sym])
    end

    Plan.find_by(package_name: 'funnel_development_starter').update(
      amount: 1000, min_recommended_price: 1500
    )
  end

  private

  def ala_carte_changes
    {
      template_landing_page: 675,
      custom_landing_page: 2000,
      ads_creatives: 675,
      call_tracking: 70 ,
      seo_audit_lite: 675,
      seo_audit_advanced: 1350,
      google_ads_audit: 475,
      facebook_ads_audit: 475
    }
  end
end


