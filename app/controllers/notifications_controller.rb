# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_notification, only: :view
  def index
    unread_noti_count = current_user.notifications.unread.count
    @all_notifications = current_user.notifications.unread
    notifications = if params[:all]
                      current_user.notifications.paginate(page: params[:page], per_page: 10)
                    else
                      current_user.notifications.unread.paginate(page: params[:page], per_page: 10)
                    end
    respond_to do |format|
      format.html { render template: "notifications/index", layout: set_user_layout}
      format.json { render json: { notifications: notifications, notifications_count: unread_noti_count } }
    end
  end

  def show; end

  def view
    @notification.read!
    redirect_to @notification.path
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
