# frozen_string_literal: true
require 'task_helpers/last_contacted.rb'
include LastContacted

namespace :subscriptions do
  desc 'Send Upcoming Invoices info to admin'
  task upcoming_send_to_admin: :environment do
    if Date.current.monday?
      upcoming_subscriptions = []
      week_period_end = 7.days.after.to_date
      Agency.find_each do |agency|
        next if agency.customer_id.blank?
        stripe_subs = Stripe::Subscription.list(customer: agency.customer_id, status: 'active')
        subscriptions = []
        stripe_subs.auto_paging_each do |stripe_sub|
          sub_period_end = Time.at(stripe_sub.current_period_end).to_date
          next if sub_period_end > week_period_end
          package_sub = PackageSubscription.find_by(account_id: stripe_sub.id)
          next if stripe_sub.plan.blank?
          subscriptions.push({
            name: stripe_sub.plan.nickname,
            amount: stripe_sub.plan.amount/100,
            interval: stripe_sub.plan.interval,
            current_period_end: stripe_sub.current_period_end,
            business_name: package_sub&.business&.name
          })
        end
        next if subscriptions.blank?

        upcoming_subscriptions.push({
          agency_id: agency.id, items: subscriptions, last_contacted: last_contacted_at(agency)
        })
      # rescue Stripe::InvalidRequestError => e
      #   errors.push(e.message)
      end

      AdminMailer.upcoming_subscriptions(upcoming_subscriptions).deliver_later
    end
  end

  task active: :environment do
    stripe_subs = Stripe::Subscription.list(status: 'active')
    subscriptions = []
    cancelled = []

    stripe_subs.auto_paging_each do |stripe_sub|
      customer = Stripe::Customer.retrieve(stripe_sub.customer)
      if stripe_sub.cancel_at_period_end
        cancelled.push(customer.email.downcase)
      else
        subscriptions.push(customer.email.downcase)
      end
    end

    subscriptions.uniq!
    cancelled.uniq!
    cancelled -= subscriptions

    Hubspot.configure(
      client_id: ENV['HUBSPOT_CLIENT_ID'],
      client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
      redirect_uri: Rails.application.routes.url_helpers.auth_hubspot_callback_url,
      access_token: HubspotAuth.get_access_token
    )

    User.agency_admins.where(email: subscriptions).find_each do |user|
      Hubspot::Contact.create_or_update(user.email, {
        email: user.email,
        stripe_subscription: 'Yes',
      })
    end

    User.agency_admins.where(email: cancelled).find_each do |user|
      Hubspot::Contact.create_or_update(user.email, {
        email: user.email,
        stripe_subscription: 'Canceled',
      })
    end
  end
end
