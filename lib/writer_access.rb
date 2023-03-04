# frozen_string_literal: true

module WriterAccess
  API_URL  = ENV['WRITERACCESS_URL']
  API_USER = 'clients@oneims.info'
  API_KEY  = ENV['WRITERACCESS_API_KEY']

  def self.query_account
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get('/api/account') do |req|
      req.headers['Accept'] = 'application/json'
    end
    if JSON.parse(resp.body)['account']
      JSON.parse(resp.body)['account']
    else
      JSON.parse(resp.body)
    end
  end

  def self.calculate_price(writer_level, maxwords, proof_reading)
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.post('/api/price') do |req|
      req.headers['Accept'] = 'application/json'
      req.body = { writer: writer_level, maxwords: maxwords, paidreview: proof_reading }
    end
    if JSON.parse(resp.body)['price']
      @price = JSON.parse(resp.body)['price'] * 1.25
    else
      JSON.parse(resp.body)
    end
  end

  def self.list_categories
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get('/api/categories') do |req|
      req.headers['Accept'] = 'application/json'
    end
    JSON.parse(resp.body)['categories']
  end

  def self.list_asset_types
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get('/api/assets') do |req|
      req.headers['Accept'] = 'application/json'
    end
    JSON.parse(resp.body)['assets']
  end

  def self.list_expertises
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get('/api/expertises') do |req|
      req.headers['Accept'] = 'application/json'
    end
    JSON.parse(resp.body)['expertises']
  end

  def self.list_projects
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get('/api/projects') do |req|
      req.headers['Accept'] = 'application/json'
    end
    JSON.parse(resp.body)
  end

  def self.list_orders(status, project_id)
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get('/api/orders') do |req|
      req.headers['Accept'] = 'application/json'
      req.body = { status: status, project: project_id }
    end
    JSON.parse(resp.body)
  end

  def self.create_project(projectname)
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.post('/api/projects') do |req|
      req.headers['Accept'] = 'application/json'
      req.body = { projectname: projectname }
    end
    JSON.parse(resp.body)
  end

  def self.get_order(order_id)
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get("/api/orders/#{order_id}") do |req|
      req.headers['Accept'] = 'application/json'
    end
    JSON.parse(resp.body)
  end

  def self.create_order(order_data)
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.post('/api/orders') do |req|
      req.headers['Accept'] = 'application/json'
      req.body = order_data
    end
    if JSON.parse(resp.body)['orders']
      JSON.parse(resp.body)['orders']
    else
      JSON.parse(resp.body)
    end
  end

  def self.list_field_layout
    conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.get('/api/layouts') do |req|
      req.headers['Accept'] = 'application/json'
    end
    JSON.parse(resp.body)
  end

  def self.preview_order(order_id)
    conn = conn = Faraday.new(url: API_URL)
    conn.basic_auth(API_USER, API_KEY)
    resp = conn.post("/api/orders/#{order_id}?action=preview") do |req|
      req.headers['Accept'] = 'application/json'
    end
    JSON.parse(resp.body)
  end
end
