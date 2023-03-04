class RemoveColumnPaidWhiteLabeledFeaturesFromAgencies < ActiveRecord::Migration[5.1]
  def change
    remove_column :agencies, :paid_white_labeled_features
  end
end
