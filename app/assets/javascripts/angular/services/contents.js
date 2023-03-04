clickxApp.factory('ContentOrder', [
  '$resource',
  function($resource) {
    return $resource(
      '/content_order/:id.json',
      {},
      {
        content_order_form_data: {
          url: '/content_order/form_data.json',
          method: 'GET'
        },
        calculate_article_price: {
          url: '/content_order/calculate_article_price',
          method: 'POST'
        },
        business_cards_list: {
          url: '/content_order/business_cards_list',
          method: 'POST'
        },
        content_order_create: { url: '/content_order', method: 'POST' },
        content_order_update: {
          url: '/content_order/:id',
          method: 'PUT',
          params: { id: '@id' }
        },
        view_order: { url: '/content_order', method: 'GET' },
        content_order_get: { url: '/content_order/:id', method: 'GET' },
        all_orders: { url: '/content_order/complete_orders', method: 'GET' },
        admin_place_order: {
          url: '/content_order/:id/place_order_admin',
          method: 'GET'
        },
        content_order_default: {
          url: '/content_order_defaults',
          method: 'POST'
        },
        content_order_default_show: {
          url: '/content_order_defaults/default_by_business',
          method: 'GET'
        },
        content_order_default_update: {
          url: '/content_order_defaults/:id',
          method: 'PUT',
          params: { id: '@id' }
        }
      }
    );
  }
]);
