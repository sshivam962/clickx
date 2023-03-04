#user role setting for agencies

namespace :user_roles do
  desc 'Data insertion for agency roles'
  task insert_roles_data: :environment do
    
    PERMISSION_INFO = [
    	'leads_agency_permission',
    	'packages_agency_permission',
    	'grader_reports_agency_permission',
	    'roi_agency_permission',
	    'industries_agency_permission',
	    'documents_agency_permission',
	    'portfolio_agency_permission',
	    'branding_agency_permission',
	    'projects_agency_permission',
	    'badges_agency_permission',
	    'courses_agency_permission',
	    'scale_program_agency_permission',
	    'payment_links_agency_permission',
	    'affiliate_dashboard_agency_permission',
	    'agency_infrastructure_agency_permission',
	    'agency_website_agency_permission',
	    'agency_facebook_ads_agency_permission',
	    'agency_google_ads_agency_permission',
	    'sales_coaching_agency_permission',
	    'support_agency_permission',
	    'faqs_agency_permission',
	    'community_agency_permission'
	]
	
	PERMISSION_INFO.each do |perm|

		role = Role.find_or_create_by(name: perm)
		puts "role info: #{role.name}"

		User.where(role: 'agency_admin').each do |user|
		
			user.roles << role
			
	    end
	end
  end
end
