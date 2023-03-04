class CreateOutscrapperData < ActiveRecord::Migration[5.2]
  def change
    create_table :outscrapper_data do |t|
      t.references :outscrapper_request
      t.jsonb :response_json
      t.jsonb :cleaned_json
    end
  end
end
