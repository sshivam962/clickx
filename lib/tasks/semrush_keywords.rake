namespace :semrush do
  desc 'Update businesses with their SEMrush keywords data'

  # THIS RAKE TASK IS NOT USED ANYMORE, BUT IT'S KEPT HERE FOR REFERENCE
  # THE TASK IS MOVED TO CLICKX-WORKERS APP
  task update_keywords: :environment do
    next unless Date.current.monday?

    businesses = Business.not_deleted.where.not(semrush_project_id: [nil, ''])
    businesses.find_each(batch_size: 10) do |business|
      SemrushKeywordsJob.perform_async(business.id)
    end
  end
end
