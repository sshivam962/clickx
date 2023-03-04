# frozen_string_literal: true

class SuperAdmin::LocationPolicy < ApplicationPolicy

  def update?
    can_manage?
  end

  def export_csv?
    clients?
  end

  def map?
    location_map?
  end

  private

  def can_manage?
    clients?
  end
end
