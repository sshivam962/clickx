class RemoveLogoFromIndustries < ActiveRecord::Migration[5.1]
  def change
    remove_column :industries, :logo, :string
  end
end
