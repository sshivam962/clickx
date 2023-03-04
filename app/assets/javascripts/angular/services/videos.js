clickxApp.factory('Videos', [
  '$resource',
  function($resource) {
    return $resource(
      '/videos.json',
      {},
      {
        query: { method: 'GET', isArray: true },
        categories_list: {
          url: '/categories_list',
          method: 'GET',
          isArray: true
        },
        create: { method: 'POST' },
        academy: { url: '/academy', method: 'GET', isArray: true }
      }
    );
  }
]);

clickxApp.factory('Video', [
  '$resource',
  function($resource) {
    return $resource(
      '/videos/:id.json',
      {},
      {
        show: { method: 'GET' },
        update: { method: 'PUT', params: { id: '@id' } },
        delete: { method: 'DELETE', params: { id: '@id' } }
      }
    );
  }
]);
