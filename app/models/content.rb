# frozen_string_literal: true

Diffy::Diff.default_format = :html
class Content < ApplicationRecord
  has_paper_trail
  include AASM
  ContentStates = %w[draft review review_submitted final_proof approved].freeze

  has_many :comments
  has_many :state_trackers
  belongs_to :business

  aasm column: :state do
    state :draft, initial: true
    state :review
    state :review_submitted
    state :final_proof
    state :approved

    event :submit_review, after: :notify_user_for_review do
      transitions to: :review, from: :draft
    end

    event :submit_feedback, after: :notify_admin_for_feedback do
      transitions to: :review_submitted, from: :review
    end

    event :final_proof do
      transitions to: :final_proof, from: :review_submitted
    end

    event :approve do
      transitions to: :approved, from: :review
      transitions to: :approved, from: :review_submitted
      transitions to: :approved, from: :final_proof
    end
  end

  validates :title, :state, presence: true

  validates :state, inclusion: {
    in: ContentStates,
    message: 'not a valid state'
  }

  before_validation(on: :create) do
    self.state = ContentStates[0]
  end

  def as_json(options = {})
    if options.key?(:for_view)
      data = super(options)
      data = data.merge(get_comments: get_comments)
      data = data.merge(state_trackers: get_state_trackers)
      data = data.merge(content_difference: get_latest_content_difference)
      data
    else
      super
    end
  end

  def get_latest_content_difference
    difference = {}
    last_audit = versions.last
    if last_audit
      last_change = last_audit.try(:changeset)
      last_change.each do |key, val|
        difference[key] = Diffy::Diff.new(val[0], val[1]).to_s
        difference[key] = CGI.unescapeHTML(difference[key])
      end
      difference[:updated_at] = last_audit.changeset[:updated_at][1].strftime('%m-%d-%Y')
      difference[:user] = User.where(id: versions.last.whodunnit).try(:first).try(:name)
    end
    difference.as_json
  end

  def get_comments
    comments.as_json
  end

  def get_state_trackers
    state_trackers.as_json
  end

  def notify_user_for_review
    Thread.new do
      biz = business
      biz_users = biz.users.business_users_mailing_list
      Notifier.content_submitted_to_customer(self, biz_users.pluck(:email), biz.id).deliver_now
      biz_users.each do |receipient|
        receipient.notifications.create(
          actor: nil,
          target: self,
          action: 'comment.notify_user_for_review'
        )
      end
    end
  end

  def notify_admin_for_feedback
    Thread.new do
      Notifier.content_feedback_from_customer(self, 'support@clickx.io').deliver_now
      User.admins_mailing_list.each do |receipient|
        receipient.notifications.create(
          actor: nil,
          target: self,
          action: 'comment.notify_admin_for_feedback'
        )
      end
    end
  end

  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :all_blank
end
