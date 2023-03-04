class AddTierToCourses < ActiveRecord::Migration[5.1]
  def up
    add_column :courses, :tier, :integer
    Course.where(free: true).update_all(tier: 'starter')
    remove_column :courses, :free
  end

  def down
    add_column :courses, :free, :boolean
    Course.where(tier: 'starter').update_all(free: true)
    remove_column :courses, :tier
  end
end
