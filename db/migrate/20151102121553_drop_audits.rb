class DropAudits < ActiveRecord::Migration[4.2]
  def change
    drop_table :espinita_audits
  end
end
