# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :set_resource, only: :create

  def create
    FeedbackMailer.send_mail(
      current_user, @resource, params[:suggestion]
    ).deliver_later
  end

  private

  def set_resource
    @resource = current_business || current_agency
  end
end
