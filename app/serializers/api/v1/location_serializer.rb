# frozen_string_literal: true

module Api
  module V1
    class LocationSerializer < ActiveModel::Serializer
      attributes :id, :name, :address, :city, :state, :country, :zip, :phone,
                 :mobile_phone, :toll_free, :website, :enquiry_email, :fax, :categories,
                 :payment_methods, :products_services, :brands, :images, :languages,
                 :professional_associations, :slogan, :keywords, :short_description,
                 :medium_description, :full_description, :long_description, :number_of_users,
                 :year_established, :user_id, :created_at, :updated_at, :business_id,
                 :local_profile_list, :local_profile_last_upload, :lat, :lng, :operational_hours,
                 :positive_review_coupon, :negative_review_coupon, :slug, :short_url,
                 :reviews_count, :bl_reviews_info, :average_rating, :contact_name
    end
  end
end
