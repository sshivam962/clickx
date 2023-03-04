# frozen_string_literal: true

module Api
  module V1
    class AgencySerializer < ActiveModel::Serializer
      attributes :id, :name, :phone, :support_email, :logo, :address
    end
  end
end
