class ReviewLink < ApplicationRecord
  belongs_to :location, optional: true

  def as_json(options = {})
    super(options.merge(except: %i[created_at updated_at]))
  end
end
