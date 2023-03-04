# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :content
  belongs_to :user
  validates :comment, presence: true

  after_find do
    self.user_name = user.name
    save if changed?
  end

  after_create do
    Thread.new do
      unless user.super_admin?
        admins = User.admins_mailing_list
        Notifier.new_comment_from_customer(content, self, admins.pluck(:email)).deliver_now if admins.present?
        User.admins_mailing_list.each do |receipient|
          receipient.notifications.create(
            actor: user,
            target: self,
            action: 'comment.created'
          )
        end
      end
    end
  end

  def as_json(options = {})
    data = super
    data = data.merge(email: user.email)
    data
  end
end
