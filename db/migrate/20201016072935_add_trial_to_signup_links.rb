class AddTrialToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :trial_interval, :string
    add_column :signup_links, :trial_interval_count, :integer
  end
end
