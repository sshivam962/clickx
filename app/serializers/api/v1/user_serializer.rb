# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :first_name, :last_name, :email, :role, :username
    end
  end
end
