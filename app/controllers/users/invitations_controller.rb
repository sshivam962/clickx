# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  layout :set_layout
  respond_to :html, :json, :js

  def new
    super
  end

  def edit
    super
  end

  def create
    inv_params =
      params[:invitation].present? ? params[:invitation][:user] : params[:user]
    resource = User.with_deleted.find_by(email: inv_params[:email]&.downcase)
    if resource.nil?
      super
    else
      resource.restore if resource.deleted?
      if resource.super_admin?
        resource.errors.add(:email, 'You can not invite super user')
      elsif resource.agency_admin? && inv_params[:ownable_type] == 'Business'
        resource.errors.add(:email, 'You can not invite an agency user')
      else
        resource.update_attribute(:ownable_id, inv_params[:ownable_id])
        resource.update_attribute(:ownable_type, inv_params[:ownable_type])
        resource.associate_ownable
        case inv_params[:ownable_type]
        when 'Business'
          UserMailer.added_to_new_campaign(resource, inv_params[:ownable_id]).deliver_later
        when 'Agency'
          UserMailer.added_to_new_agency(resource, inv_params[:ownable_id]).deliver_later
        end
        unless resource.invitation_accepted?
          if resource.invitation_sent_at.blank? || (resource.invitation_sent_at < 1.day.ago)
            resource.deliver_invitation
          end
          resource.update_attribute(:invitation_sent_at, Time.current)
        end
      end
      # respond_with resource, location: after_invite_path_for(resource)
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_layout
    %w[new create].include?(params[:action]) ? set_user_layout : 'devise'
  end
end
