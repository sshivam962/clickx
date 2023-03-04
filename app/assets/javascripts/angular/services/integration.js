clickxApp.factory('ThirdPartyIntegrationService', [
  '$resource',
  function($resource) {
    var formUrl = ' /businesses/:business_id/integration_detail';
    return $resource(
      formUrl,
      {},
      {
        query: {
          url: formUrl,
          method: 'GET',
          params: { business_id: '@business_id' },
          isArray: false
        },
        update: {
          url: formUrl,
          method: 'PUT',
          params: { business_id: '@business_id' }
        }
      }
    );
  }
]);
