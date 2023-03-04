# frozen_string_literal: true

class AddToKeywordBankJob
  include Sidekiq::Worker

  def perform(name, city)
    ActiveRecord::Base.connection_pool.with_connection do
      keyword = Keyword.where(name: name, city: city).first_or_create

      begin
        @business.keywords << keyword
        render json: { status: 201,
                       business: @business,
                       errors: @business.errors }
      rescue ActiveRecord::RecordInvalid
        render json: { status: 406,
                       business: @business,
                       error: '#{keyword.name} Keyword Already Exists' }
      end
    end
  end
end
