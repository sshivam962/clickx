# frozen_string_literal: true

class SuperAdmin::LeadPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def show?
    can_manage?
  end

  def export_csv?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def update?
    can_manage?
  end

  def info?
    can_manage?
  end

  def old_strategy?
    can_manage?
  end

  private

  def can_manage?
    leads?
  end

end
