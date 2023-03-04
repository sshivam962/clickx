class AddFormIdToTrackerFormSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_form_submissions,:form_id,:string
  end
end
