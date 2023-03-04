class AddContactToTrackerFormSubmission < ActiveRecord::Migration[4.2]
  def change
    add_reference :tracker_form_submissions, :tracker_contact, index: true, foreign_key: true
  end
end
