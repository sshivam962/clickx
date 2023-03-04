class Project < ApplicationRecord
  belongs_to :agency
  has_many :project_proposals
  belongs_to :accepted_proposal, class_name: 'ProjectProposal', foreign_key: :accepted_proposal_id, optional: true

  scope :accepted, -> { where.not(accepted_proposal_id: nil) }

  PROJECT_TYPES = [
    'Affiliate Marketing',
    'Content Marketing',
    'Email Marketing',
    'Graphic Design',
    'Influencer Marketing',
    'Marketing Analytics',
    'Marketing Automation',
    'Marketing Funnels',
    'Paid Advertising',
    'Partnership Marketing',
    'Public Relations (PR)',
    'Search Engine Marketing',
    'Search Engine Optimization (SEO)',
    'Social Media Marketing'
  ]

  PRIMARY_SKILLS = {
    office_and_admin: 'Office & Admin (Virtual Assistant)',
    english: 'English',
    writing: 'Writing',
    marketing_and_sales: 'Marketing & Sales',
    advertising: 'Advertising',
    web_development: 'Web Development',
    web_master: 'Web Master',
    graphics_and_multimedia: 'Graphics & Multimedia',
    software_development_or_programming: 'Software Development/ Programming',
    finance_and_management: 'Finance & Management',
    customer_service_and_admin_support: 'Customer Service & Admin Support',
    professional_services: 'Professional Services',
    project_management: 'Project Management'
  }

  SECONDARY_SKILLS = {
    office_and_admin: {
      admin_assistant: 'Admin Assistant',
      appointment_setter: 'Appointment Setter',
      data_entry: 'Data Entry',
      email_management: 'Email Management',
      event_planner: 'Event Planner',
      excel: 'Excel',
      human_resource_management: 'Human Resource Management',
      personal_assistant: 'Personal Assistant',
      project_coordinator: 'Project Coordinator',
      quality_assurance: 'Quality Assurance',
      recruitment_assistant: 'Recruitment Assistant',
      research: 'Research',
      transcription: 'Transcription',
      travel_planning: 'Travel Planning'
    },
    english: {
      speaking: 'Speaking',
      translation: 'Translation',
      tutoring_teaching: 'Tutoring Teaching',
      writing: 'Writing'
    },
    writing: {
      blogging: 'Blogging',
      copywriting: 'Copywriting',
      creative_writing: 'Creative Writing',
      ebook_writing: 'Ebook Writing',
      editing_proofreading: 'Editing Proofreading',
      ghost_writing: 'Ghost Writing',
      technical_writing: 'Technical Writing',
      web_content: 'Web Content',
      writing: 'Writing'
    },
    marketing_and_sales: {
      affiliate_marketing: 'Affiliate Marketing',
      classified_ads_marketing: 'Classified Ads Marketing',
      craigslist_marketing: 'Craigslist Marketing',
      direct_mail_marketing: 'Direct Mail Marketing',
      email_marketing: 'Email Marketing',
      facebook_marketing: 'Facebook Marketing',
      instagram_marketing: 'Instagram Marketing',
      lead_generation: 'Lead Generation',
      linkedIn_marketing: 'LinkedIn Marketing',
      mobile_marketing: 'Mobile Marketing',
      private_blog_network: 'Private Blog Network',
      sales_representative: 'Sales Representative',
      sem: 'SEM',
      seo: 'SEO',
      social_media_marketing: 'Social Media Marketing',
      telemarketing: 'Telemarketing',
      video_marketing: 'Video Marketing',
      youTube_marketing: 'YouTube Marketing'
    },
    advertising: {
      amazon_product_ads: 'Amazon Product Ads',
      bing_ads: 'Bing Ads',
      creative_advertising: 'Creative advertising',
      facebook_ads: 'Facebook Ads',
      google_adwords: 'Google AdWords',
      instagram_ads: 'Instagram Ads',
      media_buys: 'Media Buys',
      other_ad_platforms: 'Other Ad Platforms',
      scientific_advertising: 'Scientific advertising',
      youtube_ads: 'Youtube Ads'
    },
    web_development: {
      angular_js: 'AngularJS',
      asp_net: 'ASP.NET',
      click_funnels: 'ClickFunnels',
      drupal_development: 'Drupal Development',
      infusionsoft: 'Infusionsoft',
      javascript: 'Javascript',
      joomla_development: 'Joomla Development',
      laravel: 'Laravel',
      magento: 'Magento',
      mysql: 'Mysql',
      node_js: 'Node.js',
      optimizepress: 'Optimizepress',
      php: 'PHP',
      react: 'React',
      ruby_on_rails: 'Ruby on Rails',
      shopify: 'Shopify',
      vue_js: 'VueJS',
      woocommerce: 'WooCommerce',
      wordpress_development: 'Wordpress Development'
    },
    web_master: {
      content_management: 'Content Management',
      css: 'Css',
      drupal: 'Drupal',
      ecommerce_or_shopping_carts: 'Ecommerce / Shopping Carts',
      google_analytics: 'Google analytics',
      html: 'Html',
      joomla: 'Joomla',
      managing_servers: 'Managing Servers',
      psd_to_html: 'PSD to HTML',
      webmaster_tools: 'Webmaster Tools',
      wordpress: 'Wordpress'
    },
    graphics_and_multimedia: {
      three_d_modeling: '3D Modeling',
      adobe_indesign: 'Adobe Indesign',
      animation_specialist: 'Animation Specialist',
      Autocad: 'Autocad',
      graphics_editing: 'Graphics Editing',
      illustrator: 'Illustrator',
      logo_design: 'Logo Design',
      photoshop: 'Photoshop',
      print_design: 'Print Design',
      recording_audio: 'Recording Audio',
      shirt_design: 'Shirt Design',
      user_interface_design: 'User Interface Design',
      video_editing: 'Video Editing',
      web_page_design: 'Web page Design'
    },
    software_development_or_programming: {
      android_development: 'Android development',
      c_hash: 'C#',
      desktop_applications: 'Desktop Applications',
      game_development: 'Game development',
      ios_development: 'iOS development',
      Python: 'Python',
      software_qa_testing: 'Software QA Testing'
    },
    finance_and_management: {
      accounting: 'Accounting',
      bookkeeping: 'Bookkeeping',
      business_plans: 'Business Plans',
      financial_analysis: 'Financial Analysis',
      financial_forecasting: 'Financial Forecasting',
      financial_management: 'Financial Management',
      inventory_management: 'Inventory Management',
      investment_researching: 'Investment Researching',
      payroll: 'Payroll',
      quickbooks: 'Quickbooks',
      strategic_planning: 'Strategic Planning',
      tax_preparation: 'Tax Preparation',
      xero: 'Xero'
    },
    customer_service_and_admin_support: {
      community_forum_moderation: 'Community Forum Moderation',
      content_moderation: 'Content Moderation',
      customer_support: 'Customer Support',
      email_support: 'Email Support',
      phone_support: 'Phone Support',
      social_media_moderation: 'Social Media Moderation',
      tech_support: 'Tech Support'
    },
    professional_services: {
      architectural_and_engineering_services: 'Architectural and Engineering Services',
      legal_services: 'Legal Services',
      medical_services: 'Medical Services',
      real_estate_services: 'Real Estate Services'
    },
    project_management: {
      design_project_management: 'Design Project Management',
      marketing_project_management: 'Marketing Project Management',
      other_project_management: 'Other Project Management',
      software_development_project_management: 'Software Development Project Management',
      web_development_project_management: 'Web Development Project Management',
      writing_project_management: 'Writing Project Management'
    }
  }
end
