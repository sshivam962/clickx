clickxApp.factory('CustomUrls', [
  '$resource',
  function($resource) {
    return $resource(
      '/custom_urls.json',
      {},
      {
        query: { method: 'GET' },
        create: { method: 'POST' }
      }
    );
  }
]);

clickxApp.factory('CustomUrl', [
  '$resource',
  function($resource) {
    return $resource(
      '/custom_urls/:id.json',
      {},
      {
        delete: { method: 'DELETE', params: { id: '@id' } },
        update: { method: 'PUT', params: { id: '@id' } }
      }
    );
  }
]);
