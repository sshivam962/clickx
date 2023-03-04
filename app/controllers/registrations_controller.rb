# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  layout :set_layout

  def edit
    super
  end

  protected

  def update_resource(resource, params)
    if resource.identities.present?
      resource.update_without_password(params)
    else
      super
    end
  end

  private

  def set_layout
    current_user.present? ? set_user_layout : 'devise'
  end
end
