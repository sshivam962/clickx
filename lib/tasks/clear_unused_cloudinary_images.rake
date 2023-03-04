# frozen_string_literal: true

require 'rake'

desc 'Deleting unused social post images'
task clear_unused_cloudinary_images: :environment do
  deleted_resources = Cloudinary::Api.delete_resources_by_tag('browser_uploads')
  while deleted_resources.key?('next_cursor')
    next_resources = Cloudinary::Api.delete_resources_by_tag('browser_uploads', next_cursor: deleted_resources['next_cursor'])
    if !next_resources['next_cursor'].nil?
      deleted_resources['next_cursor'] = next_resources['next_cursor']
    else
      deleted_resources.delete('next_cursor')
    end
  end
end
