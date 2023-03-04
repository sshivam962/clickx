# frozen_string_literal: true

module DashboardHelper
  def calculated_search_ads_data data
    data = data[:total_details]
    return {} if data.blank?

    cost = number_to_currency(data[:cost]&.to_f/1000000, precision: 2)
    avg_cost = number_to_currency(data[:average_cost]&.to_f/1000000, precision: 2)
    cost_per_conv = number_to_currency((data[:cost]&.to_f/1000000/data[:conversions].to_i), precision: 2)
    cpc = number_to_currency((data[:cost]&.to_f/1000000)/data[:clicks], precision: 2)
    conversion_rate = number_to_percentage(data[:conversions]&.to_f/data[:interactions], precision: 2)

    {
      clicks: data[:interactions],
      impressions: data[:impressions],
      conversion: data[:conversions].to_i,
      ctr: data[:ctr],
      cpc: cpc,
      cost_per_conv: cost_per_conv,
      avg_cost: avg_cost,
      cost: cost,
      conversion_rate: conversion_rate
    }
  end

  def is_visible_ads_data(data)
    data[:clicks] != 0 && data[:ctr] != 0
  end
end
