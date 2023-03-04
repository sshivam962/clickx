clickxApp.factory('Groups', [
  '$resource',
  function($resource) {
    return $resource(
      '/groups.json',
      {},
      {
        query: { method: 'GET', isArray: true },
        create: { method: 'POST' }
      }
    );
  }
]);

clickxApp.factory('Group', [
  '$resource',
  function($resource) {
    return $resource(
      '/groups/:id.json',
      {},
      {
        show: { method: 'GET' },
        update: { method: 'PUT', params: { id: '@id' } },
        delete: { method: 'DELETE', params: { id: '@id' } }
      }
    );
  }
]);
