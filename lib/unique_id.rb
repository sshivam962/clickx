# frozen_string_literal: true

module UniqueId
  def assign_unique_id
    existing_ids = self.class.all.pluck(:unique_id)
    new_id = (existing_ids.compact.max || 1000).to_i + 1
    new_id = 1000 if existing_ids.compact.blank?

    self.unique_id = new_id
  end
end
