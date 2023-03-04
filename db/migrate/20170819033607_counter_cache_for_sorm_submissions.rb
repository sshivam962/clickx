class CounterCacheForSormSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contact_forms, :submissions_count, :integer, default: 0
    add_column :page_forms, :submissions_count, :integer, default: 0
    PageForm.update_all(
      <<-SQL.squish
      submissions_count = (
      SELECT count(1) FROM tracker_form_submissions 
      WHERE tracker_form_submissions.parent_id = page_forms.id AND tracker_form_submissions.parent_type = 'PageForm'
      )
    SQL
    )
    TrackerContactForm.update_all(
      <<-SQL.squish
      submissions_count = (
      SELECT count(1) FROM tracker_form_submissions 
      WHERE tracker_form_submissions.parent_id = tracker_contact_forms.id AND tracker_form_submissions.parent_type = 'TrackerContactForm'
      )
    SQL
    )
    HelloBar.update_all(
      <<-SQL.squish
      submissions_count = (
      SELECT count(1) FROM tracker_form_submissions 
      WHERE tracker_form_submissions.parent_id = hello_bars.id AND tracker_form_submissions.parent_type = 'HelloBar'
      )
    SQL
    )

  end
end
