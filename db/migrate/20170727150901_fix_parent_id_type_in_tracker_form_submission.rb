class FixParentIdTypeInTrackerFormSubmission < ActiveRecord::Migration[4.2]
  def change
    change_column :tracker_form_submissions, :parent_id, 'integer USING parent_id::integer'
  end
end
