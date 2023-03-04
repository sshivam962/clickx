# frozen_string_literal: true

class Public::ValueHooksController < PublicController
  before_action :set_value_hooks
  before_action :set_agency

  def show; end

  private

  def set_value_hooks
    @value_hook ||= ValueHook.find_obfuscated(params[:id])
  end

  def set_agency
    @agency ||= Agency.find_obfuscated(params[:agency_id])
  end

end
