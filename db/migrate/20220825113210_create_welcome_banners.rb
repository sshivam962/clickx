class CreateWelcomeBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :welcome_banners do |t|
      t.text :body_text
      t.string :body_link
      t.string :body_bg_color
      t.string :body_text_color
      t.string :call_to_action
      t.string :body_link_color 
      t.boolean :active, default: true

      t.timestamps
    end

    WelcomeBanner.create( body_text: 'Next Coaching Call: Tuesday at 3PM EST on Sales Training',
                          body_link: '#0',
                          body_bg_color:'#ff9800',
                          body_text_color:'#fff',
                          body_link_color: '#000',
                          active: false) 
  end
end
