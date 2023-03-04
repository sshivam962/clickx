clickxApp.factory('FbLeads', [
  '$resource',
  function($resource) {
    var url = '/businesses/:business_id/fb_lead_gen_subscriptions';
    return $resource(
      url,
      {},
      {
        query: { method: 'GET' },
        subscribe: { method: 'POST' },
        unsubscribe: { url: url + '/:page_id', method: 'DELETE' },
        pages: {
          url: '/businesses/:business_id/facebook_leads',
          method: 'GET',
          isArray: false
        },
        subscribed_pages: {
          url: '/businesses/:business_id/facebook_leads/subscribed_pages',
          method: 'GET',
          isArray: false
        },
        update: {
          url: '/businesses/:id/facebook_leads/update_access_token',
          method: 'PUT',
          params: { id: '@id' }
        },
        destroy: {
          url: '/businesses/:id/facebook_leads/delete_access_token',
          method: 'DELETE'
        }
      }
    );
  }
]);
