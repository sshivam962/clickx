# frozen_string_literal: true

# Actor. The object that performed the activity.
# Action. The verb phrase that identifies the action of the activity.
# Target. (Optional) The object to which the activity was performed.
# Eg: John Doe (actor) edited (notify_type) location_category (action) on  location (target) 12 hours ago
class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :actor, polymorphic: true, optional: true
  belongs_to :target, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }

  after_create :run

  def read?
    read_at.present?
  end

  def read!
    update(read_at: Time.current)
  end

  def actor_name
    return ' ' if actor.blank?
    actor.name
  end

  def actor_avatar_url; end

  def actor_profile_url; end

  def path
    case action
    when 'questionnaire.answered'
      '#/questions'
    when 'payment.new_content_order'
      '/'
    when 'comment.created'
      '/'
    when 'comment.notify_admin_for_feedback'
      "/#/#{target.business.id}/reviews/#{target.location_id}" rescue '/'
    when 'comment.notify_user_for_review'
      "/#/#{target.business.id}/reviews/#{target.location_id}" rescue '/'
    when 'location.updated'
      '/#/locations'
    else
      '/'
    end
  end

  def content
    case action
    when 'questionnaire.answered'
      'Questionnaire answered'
    when 'payment.new_content_order'
      'New content order'
    when 'comment.created'
      'New comment created'
    when 'comment.notify_admin_for_feedback'
      'Feed back required in comment'
    when 'comment.notify_user_for_review'
      'New review'
    when 'location.updated'
      "Location #{target.name} updated" rescue 'Location updated'
    else
      action
    end
  end

  def run
    return false if read?
    user.webpush_subscriptions.each do |subscription|
      subscription.send_message(
        {
          body: content,
          url:  view_path
        }.to_json
      )
    rescue Webpush::InvalidSubscription => e
      subscription.destroy
      Rails.logger.info "[Notification] #{e.message}"
    end
  end

  def view_path
    view_notification_path(self)
  end

  def self.read!(ids = [])
    return if ids.blank?
    where(id: ids).update_all(read_at: Time.current)
  end

  def self.unread_count(user)
    where(user: user).unread.size
  end
end
