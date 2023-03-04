# frozen_string_literal: true

class CloseioJob < ApplicationJob
  include Close

  def perform(user)
    ActiveRecord::Base.connection_pool.with_connection do
      user.add_to_closeio if user.business_user?
    end
  end
end
