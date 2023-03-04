# frozen_string_literal: true

class SuperAdmin::Lead::StrategyItemPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def new?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def create?
    can_manage?
  end

  def update?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def favorite?
    can_manage?
  end

  def load_item?
    can_manage?
  end

  private

  def can_manage?
    lead_strategy_item? || leads?
  end
end
