# frozen_string_literal: true

class WebpushSubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :endpoint, :p256dh, :auth, :user_visible_only
end
