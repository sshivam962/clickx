# frozen_string_literal: true

namespace :system do
  desc 'add system users to existing companies'
  task add_system_users: :environment do
    Business.all.each do |biz|
      biz.create_clickx_user if biz.users.where(preview_user: true).count == 0
    end
  end

  desc 'as changed associations, we need to create BusinessUser entries'
  task change_existing_business_user_assoc: :environment do
    User.all.each do |user|
      user.businesses << Business.find(user.business_id) if user.business_id
    end
  end
end
