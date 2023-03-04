clickxApp.factory('Reviews', [
  '$resource',
  function($resource) {
    return $resource(
      '/reviews.json',
      {},
      {
        query: { method: 'GET', isArray: true },
        create: { method: 'POST' }
      }
    );
  }
]);

clickxApp.factory('Review', [
  '$resource',
  function($resource) {
    return $resource(
      '/reviews/:id.json',
      {},
      {
        delete: { method: 'DELETE', params: { id: '@id' } },
        send_mail: { url: '/reviews/:id/send_mail', method: 'POST', params: { id: '@id' } },
        send_mail_with_id: { url: '/send_mail', method: 'POST', params: { email: '@email' } }
      }
    );
  }
]);
