class AddWhiteGloveFeesToBundlePackages < ActiveRecord::Migration[5.1]
  def change
    add_column :bundle_packages, :white_glove_fees, :float
  end
end
