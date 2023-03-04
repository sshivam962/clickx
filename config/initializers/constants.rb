DOMAIN_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix

EMPTY = [nil, '']

REVIEW_DIRS = {
  '2FINDLOCAL' => {
    'name' => '2 Find Local',
    'directory' => '2findlocal'
  },

  '8COUPONS' => {
    'name' => '8 Coupons',
    'directory' => '8coupons'
  },

  'ABLOCAL' => {
    'name' => 'ABLocal',
    'directory' => 'ablocal'
  },

  'AMERICANTOWNSCOM' => {
    'name' => 'AmericanTowns.com',
    'directory' => 'americantownscom'
  },

  'AROUNDME' => {
    'name' => 'AroundMe',
    'directory' => 'aroundme'
  },

  'AVANTAR' => {
    'name' => 'Avantar',
    'directory' => 'avantar'
  },

  'BING' => {
    'name' => 'Bing',
    'directory' => 'bing'
  },

  'BIZWIKICOM' => {
    'name' => 'BizWiki',
    'directory' => 'bizwikicom'
  },

  'BROWNBOOKNET' => {
    'name' => 'Brownbook',
    'directory' => 'brownbooknet'
  },

  'CHAMBEROFCOMMERCECOM' => {
    'name' => 'ChamberofCommerce.com',
    'directory' => 'chamberofcommercecom'
  },

  'CITYMAPS' => {
    'name' => 'Citymaps',
    'directory' => 'citymaps'
  },

  'CITYSEARCH' => {
    'name' => 'Citysearch',
    'directory' => 'citysearch'
  },

  'CITYSQUARES' => {
    'name' => 'CitySquares',
    'directory' => 'citysquares'
  },

  'COPILOT' => {
    'name' => 'CoPilot',
    'directory' => 'copilot'
  },

  'CREDIBILITYCOM' => {
    'name' => 'Credibility.com',
    'directory' => 'credibilitycom'
  },

  'CREDIBILITYREVIEW' => {
    'name' => 'Credibility Review',
    'directory' => 'credibilityreview'
  },

  'CYLEX' => {
    'name' => 'Cylex',
    'directory' => 'cylex'
  },

  'ELOCAL' => {
    'name' => 'eLocal',
    'directory' => 'elocal'
  },

  'EZLOCAL' => {
    'name' => 'EZlocal',
    'directory' => 'ezlocal'
  },

  'FACEBOOK' => {
    'name' => 'Facebook',
    'directory' => 'facebook'
  },

  'FOURSQUARE' => {
    'name' => 'FourSquare',
    'directory' => 'foursquare'
  },

  'GETFAVE' => {
    'name' => 'GetFave',
    'directory' => 'getfave'
  },

  'GOLOCAL247' => {
    'name' => 'GoLocal247',
    'directory' => 'golocal247'
  },

  'GOOGLEPLACES' => {
    'name' => 'Google Places',
    'directory' => 'google'
  },

  'GOOGLEMYBUSINESS' => {
    'name' => 'Google My Business',
    'directory' => 'googlemybusiness'
  },

  'HOTFROG' => {
    'name' => 'Hotfrog',
    'directory' => 'hotfrog'
  },

  'IBEGIN' => {
    'name' => 'iBegin',
    'directory' => 'ibegin'
  },

  'IGLOBAL' => {
    'name' => 'iGlobal',
    'directory' => 'iglobal'
  },

  'INSIDERPAGES' => {
    'name' => 'Insider Pages',
    'directory' => 'insiderpages'
  },

  'LOCALDATABASE'=> {
    'name' => 'Local Database',
    'directory' => 'localdatabase'
  },

  'LOCALCOM' => {
    'name' => 'LocalDotCom',
    'directory' => 'localcom'
  },

  'LOCALDOTCOM' => {
    'name' => 'LocalDotCom',
    'directory' => 'localcom'
  },

  'LOCALPAGES' => {
    'name' => 'Local Pages',
    'directory' => 'localpages'
  },

  'LOCALSTACK' => {
    'name' => 'Local Stack',
    'directory' => 'localstack'
  },

  'MAPQUEST' => {
    'name' => 'Map Quest',
    'directory' => 'mapquest'
  },

  'MERCHANTCIRCLE' => {
    'name' => 'MerchantCircle',
    'directory' => 'merchantcircle'
  },

  'MYLOCALSERVICES' => {
    'name' => 'My Local Services',
    'directory' => 'mylocalservices'
  },

  'N49CA' => {
    'name' => 'N49CA',
    'directory' => 'n49ca'
  },

  'NAVMII' => {
    'name' => 'Navmii',
    'directory' => 'navmii'
  },

  'OPENDI' => {
    'name' => 'Opendi',
    'directory' => 'opendi'
  },

  'POINTCOM' => {
    'name' => 'PointCom',
    'directory' => 'pointcom'
  },

  'SHOWMELOCAL' => {
    'name' => 'ShowMeLocal',
    'directory' => 'showmelocal'
  },

  'SUPERPAGES' => {
    'name' => 'SuperPages',
    'directory' => 'superpages'
  },

  'TOPIX' => {
    'name' => 'Topix',
    'directory' => 'topix'
  },

  'TUPALO' => {
    'name' => 'Tupalo',
    'directory' => 'tupalo'
  },

  'USCITYNET' => {
    'name' => 'USCity',
    'directory' => 'uscitynet'
  },

  'VOTEFORTHEBEST' => {
    'name' => 'VotefortheBest',
    'directory' => 'voteforthebest'
  },

  'WHERETO' => {
    'name' => 'WhereTo',
    'directory' => 'whereto'
  },

  'WHITEPAGES' => {
    'name' => 'White Pages',
    'directory' => 'whitepages'
  },

  'YAHOO' => {
    'name' => 'Yahoo',
    'directory' => 'yahoo'
  },

  'YALWA' => {
    'name' => 'Yalwa',
    'directory' => 'yalwa'
  },

  'YASABE' => {
    'name' => 'YaSabe',
    'directory' => 'yasabe'
  },

  'YELLOWISE' => {
    'name' => 'Yellowise',
    'directory' => 'yellowise'
  },

  'YELLOWMOXIE' => {
    'name' => 'YellowMoxie',
    'directory' => 'yellowmoxie'
  },

  'YELLOWPAGECITYCOM' => {
    'name' => 'YellowPageCity',
    'directory' => 'yellowpagecitycom'
  },

  'YELLOWPAGESGOESGREEN' => {
    'name' => 'YellowPagesGoesGreen',
    'directory' => 'yellowpagesgoesgreen'
  },

  'YELP' => {
    'name' => 'Yelp',
    'directory' => 'yelp'
  },

  'KUDZU' => {
    'name' => 'Kudzu',
    'directory' => 'kudzu'
  }
}

SITE_IDS = [
  '2FINDLOCAL',
  '8COUPONS',
  'ABLOCAL',
  'AMERICANTOWNSCOM',
  'AROUNDME',
  'AVANTAR',
  'BING',
  'BIZWIKICOM',
  'BROWNBOOKNET',
  'CHAMBEROFCOMMERCECOM',
  'CITYMAPS',
  'CITYSEARCH',
  'CITYSQUARES',
  'COPILOT',
  'CREDIBILITYCOM',
  'CREDIBILITYREVIEW',
  'CYLEX',
  'ELOCAL',
  'EZLOCAL',
  'FACEBOOK',
  'FOURSQUARE',
  'GETFAVE',
  'GOLOCAL247',
  'GOOGLEMYBUSINESS',
  'HOTFROG',
  'IBEGIN',
  'IGLOBAL',
  'INSIDERPAGES',
  'LOCALCOM',
  'LOCALDATABASE',
  'LOCALPAGES',
  'LOCALSTACK',
  'MAPQUEST',
  'MERCHANTCIRCLE',
  'MYLOCALSERVICES',
  'N49CA',
  'NAVMII',
  'OPENDI',
  'POINTCOM',
  'SHOWMELOCAL',
  'SUPERPAGES',
  'TOPIX',
  'TUPALO',
  'USCITYNET',
  'VOTEFORTHEBEST',
  'WHERETO',
  'WHITEPAGES',
  'YAHOO',
  'YALWA',
  'YASABE',
  'YELLOWISE',
  'YELLOWMOXIE',
  'YELLOWPAGECITYCOM',
  'YELLOWPAGESGOESGREEN',
  'YELP'
].freeze

LEAD_REGISTRATION_CALENDLY_LINK = ENV['LEAD_REGISTRATION_CALENDLY_LINK']

LOCALE_CODES = JSON.parse(File.read('public/locale.json')).freeze

HOST_CONSTRAINTS = {
  ENV['CLIENT_QUESTIONNAIRE_DOMAIN'] => ['public/inquiry/client_questionnaires'],
  ENV['GRADER_URL'] => ['public/grader_reports'],
  ENV['LEAD_STRATEGY_DOMAIN'] => ['public/lead/strategies'],
  ENV['ROMI_CALCULATOR_DOMAIN'] => ['public/roi_calculator'],
  ENV['AGENCY_CASE_STUDY_DOMAIN'] => ['public/case_studies', 'public/portfolios'],
  ENV['GROWTH_STRATEGY_DOMAIN'] => ['public/lead/strategies']
}
KICK_OFF_EXCLUDED_PACKAGES = %w[
  ala_carte jumpstart_google_ads jumpstart_facebook_ads jumpstart_seo
]

SUBSCRIPTION_RESPONSE_BANNERS = [
  'https://clickx-images.s3.amazonaws.com/success/rain.png',
  'https://clickx-images.s3.amazonaws.com/success/sale.png',
  'https://clickx-images.s3.amazonaws.com/success/game.png',
  'https://clickx-images.s3.amazonaws.com/success/fortune.png',
  'https://clickx-images.s3.amazonaws.com/success/deal.png',
  'https://clickx-images.s3.amazonaws.com/success/go.png',
  'https://clickx-images.s3.amazonaws.com/success/hustle.png',
  'https://clickx-images.s3.amazonaws.com/success/congratz.png',
  'https://clickx-images.s3.amazonaws.com/success/closing.png',
  'https://clickx-images.s3.amazonaws.com/success/coffee.png',
  'https://clickx-images.s3.amazonaws.com/success/closer.png',
  'https://clickx-images.s3.amazonaws.com/success/keep.png'
]

DEFAULT_SINGUP_LINK_CALENDLY_LINK = <<~HTML
  <!-- Calendly inline widget begin -->
  <div class="calendly-inline-widget" data-url="https://calendly.com/white-label-team/partner-onboarding" style="min-width:320px;height:630px;"></div>
  <script type="text/javascript" src="https://assets.calendly.com/assets/external/widget.js" async></script>
  <!-- Calendly inline widget end -->
HTML

CURRENCIES = {
  'USD' => '$',
  'EUR' => '€',
  'GBP' => '£'
}

EMAIL_KEY = '42334f1bbd36d19f8d55a57a885b0d72'
