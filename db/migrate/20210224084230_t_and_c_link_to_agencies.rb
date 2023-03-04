class TAndCLinkToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :t_and_c_link, :string
  end
end
