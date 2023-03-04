# frozen_string_literal: true

namespace :prospecting_lists do
  desc 'Remove duplicate entries from prospecting lists'
  task remove_duplicate_data: :environment do
    duplicate_data_arr = DirectLead.find_by_sql(
      "WITH dups AS
    (
        SELECT
            id, ROW_NUMBER() OVER (
                PARTITION BY name, lead_source_id
                ORDER BY name, lead_source_id
                ) AS Row_Number
        FROM direct_leads
    )
SELECT * FROM dups WHERE Row_Number <> 1;"
    )

    duplicate_data_arr.each {|x| DirectLead.delete(x[:id]) if DirectLead.with_deleted.find_by(id: x[:id]).sent_emails.empty?}
  end
end
