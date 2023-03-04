class AddAgencyToOutscrapperData < ActiveRecord::Migration[5.2]
  def change
    add_reference :outscrapper_data, :agency, foreign_key: true, default:nil
  end
end
