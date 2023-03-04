class AddColorBrandingFieldsToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :case_study_portfolio_header_color, :string, default: '#4C4E60'
    add_column :agencies, :strategy_product_header_color, :string, default: '#007BBE'
  end
end
