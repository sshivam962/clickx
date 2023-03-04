# When a business is delete the keyword and competitor details
# need to be send to the admin accounts.

class BusinessOnDeleteSendDetailsJob
  include Sidekiq::Worker

  def perform(business_id, business_name, business_locale)
    ActiveRecord::Base.connection_pool.with_connection do
      keyword_csv_data = if !Keyword.where(business_id: business_id).empty?
        CSV.generate do |csv|
          csv << ['Name', 'Location', 'Locale']
          Keyword.where(business_id: business_id).find_each do |keyword|
            csv << [keyword.name, keyword.city, keyword.attributes["locale"] || business_locale]
          end
        end
      else
        []
      end

      competitors_csv_data = if !Competition.where(business_id: business_id).empty?
        CSV.generate do |csv|
          csv << ['Name']
          Competition.where(business_id: business_id).select(:id, :name).order(:name).find_each do |competition|
            csv << [competition.name]
          end
        end
      else
        []
      end
      AdminMailer.deleted_business_data_collection(business_name,
                                                   keyword_csv_data,
                                                   competitors_csv_data).deliver_now!
    end
  end
end
