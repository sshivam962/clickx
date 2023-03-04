# frozen_string_literal: true

class CompetitionUpdateJob < ApplicationJob
  def perform(competition)
    ActiveRecord::Base.connection_pool.with_connection do
      competition.update_competition
    end
  end
end
