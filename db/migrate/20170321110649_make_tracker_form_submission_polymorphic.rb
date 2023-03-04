class MakeTrackerFormSubmissionPolymorphic < ActiveRecord::Migration[4.2]
  def up
    rename_column :tracker_form_submissions, :form_id, :parent_id
    add_column :tracker_form_submissions, :parent_type, :string
    TrackerFormSubmission.reset_column_information
    TrackerFormSubmission.where("data @> '[]'").update_all(parent_type: 'PageForm')
    TrackerFormSubmission.where("data @> '{}'").update_all(parent_type: 'TrackerContactForm')
  end

  def down
    rename_column :tracker_form_submissions, :parent_id, :form_id
    remove_column :tracker_form_submissions, :parent_type
  end

end
