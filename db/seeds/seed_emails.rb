[
  {
    mailer_name: "adword_query_email",
    title: "Weekly Search Terms : <Business Name>",
    to_addresses: ["gpartain@oneims.com", "darrel@oneims.com", "ppcteam@clickx.io", "natasha@oneims.com"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "budget_pacing_summary_email",
    title: "<Type> Budget Pacing - <Date>",
    to_addresses: ["gpartain@oneims.com", "darrel@oneims.com", "ppcteam@clickx.io", "natasha@oneims.com"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "budget_exceeded_clients_summary",
    title: "<Type> Budget Limit Exceeded - <Date>",
    to_addresses: ["elee@oneims.com", "gpartain@oneims.com", "maria@oneims.com", "darrel@oneims.com", "ppcteam@clickx.io", "natasha@oneims.com"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "signup_links",
    title: "Expired Signup Links",
    to_addresses: ["admin@clickx.io"],
    cc_addresses: [],
    bcc_addresses: ["andy@oneims.com"]
  },
  {
    mailer_name: "trial_users_list",
    title: "Trial Users List - <Date>",
    to_addresses: ["admin@clickx.io", "sales@clickx.io", "tim@oneims.com", "isaiah@oneims.info"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "semrush_credit_low",
    title: "SEMRush API Credits running low",
    to_addresses: ["solomon@oneims.com", "accounts@oneims.com"],
    cc_addresses: ["andy@oneims.com"],
    bcc_addresses: []
  },
  {
    mailer_name: "authority_labs_low_balance",
    title: "Clickx : Authority Labs Account Balance running low",
    to_addresses: ["solomon@oneims.com", "accounts@oneims.com"],
    cc_addresses: ["andy@oneims.com"],
    bcc_addresses: []
  },
  {
    mailer_name: "inactive_free_clients_list",
    title: "Inactive Free Clients - <Date>",
    to_addresses: ["isaiah@oneims.info"],
    cc_addresses: ["solomon@oneims.com"],
    bcc_addresses: []
  },
  {
    mailer_name: "account_costs",
    title: "Agency Cost Report <Date>",
    to_addresses: ["solomon@oneims.com", "andy@oneims.com", "accounts@oneims.com"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "agency_agreement",
    title: "Agency Agreement Signed",
    to_addresses: ["solomon@oneims.com", "andy@oneims.com", "partners@clickx.io"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "business_agreement",
    title: "Business Agreement Signed",
    to_addresses: ["solomon@oneims.com", "andy@oneims.com"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "new_signup_request",
    title: "New Signup Request",
    to_addresses: ["sales@clickx.io"],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "idle_agencies",
    title: "Idle Agencies",
    to_addresses: ["solomon@oneims.com", "sales@clickx.io", "partners@clickx.io"],
    cc_addresses: [],
    bcc_addresses: ["andy@oneims.com"]
  },
  {
    mailer_name: "idle_agencies_with_stripe",
    title: "Idle Agencies with Stripe for <Number Of Days>",
    to_addresses: ["solomon@oneims.com", "sales@clickx.io", "partners@clickx.io"],
    cc_addresses: [],
    bcc_addresses: ["andy@oneims.com"]
  },
  {
    mailer_name: "upcoming_subscriptions",
    title: "Upcoming Stripe Subscriptions - <Date>",
    to_addresses: ["solomon@oneims.com", "sales@clickx.io", "billing@clickx.io", "partners@clickx.io"],
    cc_addresses: [],
    bcc_addresses: ["andy@oneims.com"]
  },
  {
    mailer_name: "new_agency",
    title: "New Agency Created",
    to_addresses: ["clickx-home-notifications@oneims.info"],
    cc_addresses: [],
    bcc_addresses: ["andy@oneims.com"]
  },
  {
    mailer_name: "client_questionnaire",
    title: "Client Questionnaire - <client name>",
    to_addresses: ["solomon@oneims.com", "sales@clickx.io", "support@clickx.io", "hnichols@oneims.com", "elee@oneims.com", "jsainttran@oneims.com", "pwest@oneims.com"],
    cc_addresses: [],
    bcc_addresses: ["andy@oneims.com"]
  },
  {
    mailer_name: "new_signup",
    title: "New Subscription Added",
    to_addresses: [
      'solomon@oneims.com', 'samuel@oneims.com', 'jstephenson@oneims.com',
      'accounts@oneims.com', 'isaiah@oneims.com', 'sales@clickx.io',
      'solomon@clickx.io'
    ],
    cc_addresses: [],
    bcc_addresses: []
  },
  {
    mailer_name: "new_agency_signup",
    title: "New Agency Subscription Added",
    to_addresses: ["clickx-home-notifications@oneims.info"],
    cc_addresses: [],
    bcc_addresses: []
  }
].each do |attributes|
  Email.find_or_create_by(attributes)
end
