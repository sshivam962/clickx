class AddValueToBusinessColumnLogo < ActiveRecord::Migration[4.2]

  def up
    Business.includes(:locations).each do |biz|
      @logo = biz.locations.pluck(:logo).compact.first
      biz.update_attribute(:logo, @logo) if @logo
    end
    remove_column :locations, :logo
  end

  def down
    add_column :locations, :logo, :string
    Business.includes(:locations).each do |biz|
      biz.locations.update_all(logo: biz.logo) if biz.logo.present?
    end
  end
end
