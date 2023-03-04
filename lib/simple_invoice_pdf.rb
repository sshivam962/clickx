# frozen_string_literal: true
module SimpleInvoicePdf
  module_function

  def generate(invoice)
    uri = URI('https://invoice-generator.com')

    base_invoice = {
      'logo': 'https://s3.amazonaws.com/clickx-images/clickx-logo-small.png'
    }

    items =
      [{
        'name': invoice[:agency],
        'quantity': invoice[:quantity],
        'unit_cost': invoice[:unit_cost]
      }]

    params = base_invoice.merge(
      'to': "#{invoice[:agency].name}\n\n#{invoice[:agency].address}",
      'currency': invoice[:currency],
      'date': invoice[:date],
      'items': items
    )

    resp = Faraday.post(uri) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = params.to_json
    end
    resp.body
  end
end
