class AddColumnsToWriterForms < ActiveRecord::Migration[4.2]
  def change
    add_column :writer_forms, :proofreading_cost, :float
    add_column :writer_forms, :two_star_writer, :float
    add_column :writer_forms, :three_star_writer, :float
    add_column :writer_forms, :four_star_writer, :float
    add_column :writer_forms, :five_star_writer, :float
    add_column :writer_forms, :six_star_writer, :float
    add_column :writer_forms, :markup_percentage, :float
  end
end
