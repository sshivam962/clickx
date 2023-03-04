# frozen_string_literal: true

class HomeController < ApplicationController
  layout :set_layout
  skip_before_action :agency_active_check
  before_action :ensure_user_signed_in, only: %w[index clients hub]
  before_action :rails_redirect, only: :index

  def index; end

  def clients; end

  def hub; end

  def business; end

  def profile
    render layout: set_user_layout, template: user_template
  end

  def location_management
    redirect_to '/#/locations'
  end

  def campaign_intelligence
    redirect_to "/#/#{current_business.id}/questionnaire"
  end

  def switch_to_admin_user
    if get_cookie(:admin_id).present?
      user = User.find(get_cookie(:admin_id))
      @success = switch_to_user(user)
    end

    redirect_to after_sign_in_path
  end

  def switch_to_agency_user
    if params[:user_id]
      user = User.find(params[:user_id])
    elsif params[:agency_id]
      user = Agency.find(params[:agency_id]).preview_users.first
    elsif get_cookie(:agency_admin_id).present?
      user = User.find(get_cookie(:agency_admin_id))
    else
      flash[:notice] = 'Your session ended. Please login again'
      sign_out(current_user)
      redirect_to after_sign_in_path and return
    end
    @success = switch_to_user(user) if original_user.any_admin?

    redirect_to after_sign_in_path
  end

  def switch_to_business_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    elsif params[:business_id]
      @user = Business.find(params[:business_id]).preview_users.first
    end

    @success = switch_to_user(@user) if can_switch_to_business_user?(@user, params[:business_id].to_i)

    if @success && params[:feature] && params[:business_id]
      if params[:feature].eql?('dashboard')
        set_cookie(:current_business_id, params[:business_id])
        redirect_to '/b/dashboard'
      else
        redirect_to after_sign_in_path("/#/#{params[:business_id]}/#{params[:feature]}")
      end
    else
      redirect_to after_sign_in_path
    end
  end

  private

  def can_switch_to_business_user?(user, business_id)
    original_user.super_admin? ||
      (
        original_user.agency_admin? && (
          original_user.ownable.business_user_ids.include?(user&.id) ||
            business_id.eql?(Business.birch_homes.id)
        )
      )
  end

  def switch_to_user(user)
    logged_in_user = current_user

    # if user.invitation_accepted?
      sign_out(logged_in_user)
      sign_in(user)

      if logged_in_user.super_admin?
        set_cookie(:admin_id, logged_in_user.id)
      elsif logged_in_user.agency_admin?
        if user.super_admin?
          clear_cookie(:agency_admin_id)
          clear_cookie(:current_agency_id)
        else
          set_cookie(:agency_admin_id, logged_in_user.id)
          set_cookie(:current_agency_id, logged_in_user.ownable_id)
        end

      end
      # flash[:notice] = "You are now signed in as #{user.name}."
      return true
    # else
    #   flash[:error] = 'Access Denied'
    #   return false
    # end
  end

  def set_layout
    if themeX?
      if action_name == 'clients'
        'clients'
      else
        themeX_layout 'themeX'
      end
    else
      'base'
    end
  end

  def ensure_user_signed_in
    redirect_to new_user_session_path and return unless user_signed_in?
  end

  def rails_redirect
    if current_user.super_admin?
      redirect_to '/s/clients'
    elsif current_user.agency_admin?
      if current_agency.white_labeled && policy(current_agency).courses?
        redirect_to '/a/courses'
      else
        redirect_to '/a/clients'
      end
    elsif current_user.contractor?
      redirect_to '/n/dashboard'
    end
  end
end
