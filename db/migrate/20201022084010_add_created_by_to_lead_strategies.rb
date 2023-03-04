class AddCreatedByToLeadStrategies < ActiveRecord::Migration[5.1]
  def change
    add_column :lead_strategies, :created_by, :string
  end
end
