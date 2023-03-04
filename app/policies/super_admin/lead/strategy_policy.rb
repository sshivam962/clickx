# frozen_string_literal: true

class SuperAdmin::Lead::StrategyPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def list_leads?
    can_manage?
  end

  def new?
    can_manage?
  end

  def create?
    can_manage?
  end

  def update?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def approve?
    leads?
  end

  def preview?
    can_manage?
  end

  def carousel_preview?
    can_manage?
  end

  def send_approval?
    can_manage?
  end

  def reorder_items?
    can_manage?
  end

  private

  def can_manage?
    lead_strategy? || leads?
  end
end
