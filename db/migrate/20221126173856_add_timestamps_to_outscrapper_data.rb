class AddTimestampsToOutscrapperData < ActiveRecord::Migration[5.2]
  def change
    change_table :outscrapper_data do |t|
      t.timestamps default: Time.current
    end
  end
end
