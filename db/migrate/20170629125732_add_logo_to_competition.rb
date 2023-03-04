class AddLogoToCompetition < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :logo, :string, default: ''
  end
end
