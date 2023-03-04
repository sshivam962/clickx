class ClientLogoFromClearbit < ActiveRecord::Migration[4.2]
  def up
     Business.where(logo: nil).each do |business|
       logo = 
         begin
           Clearbit::Enrichment::Company.find(domain: business.domain, stream: true).logo
         rescue
           nil
         end
       business.update_attributes(logo: logo)
     end
  end
end
