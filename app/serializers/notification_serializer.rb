# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :content, :read_at, :view_path, :created_at

  delegate :view_path, to: :object
end
