# frozen_string_literal: true
class ContactsPresenter
  def initialize(model)
    @model = model
  end

  def show_profile
    model.avatar_url.nil? ? URL : model.avatar_url
  end

  def name
    model.fname.blank? ? 'NA' : "#{model.fname} #{model.lname}"
  end

  def email
    model.email.presence || 'NA'
  end

  def phone
    model.phone.presence || 'NA'
  end

  def status
    model.status.presence || 'NA'
  end

  def nationality
    model.nationality.presence || 'NA'
  end

  def organization
    model.organization.presence || 'NA'
  end

  def utm_source
    model.utm_source.presence || 'NA'
  end

  def source
    model.source.nil? ? 'NA' : model.source.humanize
  end

  def created_at
    model.created_at.to_formatted_s(:long_ordinal)
  end

  private

  URL = 'users/user_logo.png'

  attr_accessor :model
end
