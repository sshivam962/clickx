class RenameColumnCaseStudyToPaidWhiteLabeledFeatures < ActiveRecord::Migration[5.1]
  def change
    rename_column :agencies, :case_study, :paid_white_labeled_features
  end
end
