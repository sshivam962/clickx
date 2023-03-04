class CreateFunnelPages < ActiveRecord::Migration[5.1]
  def change
    create_table :funnel_pages do |t|
      t.string :title
      t.string :section_a
      t.string :section_b
      t.string :section_c
      t.string :section_d
      t.string :section_e
      t.string :section_f
      t.string :css
      t.references :agency
    end
  end
end
