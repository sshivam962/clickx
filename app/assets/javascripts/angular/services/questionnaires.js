clickxApp.factory('Questionnaires', [
  '$resource',
  function($resource) {
    return $resource(
      '/questionnaires.json',
      {},
      {
        query: {
          method: 'GET',
          params: { business_id: '@business_id' },
          isArray: true
        },
        create: { method: 'POST', params: { business_id: '@business_id' } }
      }
    );
  }
]);

clickxApp.factory('Questionnaire', [
  '$resource',
  function($resource) {
    return $resource(
      '/questionnaires.json',
      {},
      {
        show: { method: 'GET', params: { business_id: '@business_id' } },
        update: { method: 'PUT', params: { business_id: '@business_id' } },
        delete: { method: 'DELETE', params: { business_id: '@business_id' } }
      }
    );
  }
]);
