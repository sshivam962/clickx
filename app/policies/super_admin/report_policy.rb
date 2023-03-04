# frozen_string_literal: true

class SuperAdmin::ReportPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def client?
    clients?
  end

  def google_ads?
    can_manage?
  end

  def google_clients?
    can_manage?
  end

  def facebook_ads?
    can_manage?
  end

  def facebook_clients?
    can_manage?
  end

  def archive_client?
    can_manage?
  end

  def change_keyword_ranking?
    can_manage?
  end

  def keywords_export?
    can_manage?
  end

  private

  def can_manage?
    reports?
  end
end
