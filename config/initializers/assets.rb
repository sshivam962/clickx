config = Rails.application.config

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
config.assets.version = '1.0'

config.assets.paths << Rails.root.join('node_modules')

# Add additional assets to the asset load path
# config.assets.paths << Emoji.images_path
config.assets.paths << Rails.root.join('app/themes/themeX/fonts')
config.assets.paths << Rails.root.join('app/themes/themeX/images')
config.assets.paths << Rails.root.join('app/themes/themeX/javascripts')
config.assets.paths << Rails.root.join('app/themes/themeX/stylesheets')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
config.assets.precompile += %w[application.css application.js]
config.assets.precompile += %w[style.css review_pdf.css profile.js]
config.assets.precompile += %w[plain.js onboarding.css devise.css]

config.assets.precompile += %w[review-layout.css review-layout.js]
config.assets.precompile += %w[signup.css signup.js]
config.assets.precompile += %w[roi.css roi.js]
config.assets.precompile += %w[leads.css leads.js]
config.assets.precompile += %w[themeX.css themeX.js]
config.assets.precompile += %w[themeX_base.css themeX_base.js]
config.assets.precompile += %w[jquery.card.css jquery.card.js]
config.assets.precompile += %w[highcharts.css highcharts.js]
config.assets.precompile += %w[adblock_checker.css adblock_checker.js]
config.assets.precompile += %w[network.css network.js]
config.assets.precompile += %w[network_signup.css network_signup.js]

config.assets.precompile += %w[agreement.css]
config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif *.svg]
config.assets.precompile += %w[serviceworker.js manifest.json]
config.assets.precompile += %w[serviceworker-companion.js]
config.assets.precompile += %w[wicked_pdf.css]
config.assets.precompile += %w[roi_calculator.css]
config.assets.precompile += %w[ckeditor/config.js]
config.assets.precompile += %w[country_states.js]
config.assets.precompile += %w[mail_country_states.js]
config.assets.precompile += %w[plain.css]
config.assets.precompile += %w[devise.js]
config.assets.precompile += %w[checkout.js]
config.assets.precompile += %w[stripe_card.js]
config.assets.precompile += %w[stripe_card.css]
config.assets.precompile += %w[referral.css]
config.assets.precompile += %w[network/intlTelInput.min.css]
config.assets.precompile += %w[network/chats.js]
config.assets.precompile += %w[mdtimepicker.js mdtimepicker.css]

config.assets.precompile += ['public/grader.css']
config.assets.precompile += ['public/questionnaire.css']
config.assets.precompile += ['public/case_study.css']
config.assets.precompile += ['public/public_pages.css']
config.assets.precompile += ['public/lead_strategy.css']
config.assets.precompile += ['public/lead_strategy_carousel.css']
config.assets.precompile += ['public/jquery.mCustomScrollbar.min.css']
config.assets.precompile += ['public/slick.css']
config.assets.precompile += ['public/slick-theme.css']
config.assets.precompile += ['public/lead_strategy.js']
config.assets.precompile += ['public/jquery.mCustomScrollbar.concat.min.js']
config.assets.precompile += ['public/slick.min']
config.assets.precompile += ['public/strategy']
config.assets.precompile += ['public/funnel_page.css']
config.assets.precompile += ['public/payment_link.css']
config.assets.precompile += ['public/grader.js']
config.assets.precompile += ['public/payment_link.js']
