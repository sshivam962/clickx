class AddPortfolioHeaderToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :portfolio_calender_header, :string
    add_column :agencies, :casestudy_calender_header, :string
    add_column :agencies, :lead_calender_header, :string
  end
end
