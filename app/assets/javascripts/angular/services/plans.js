clickxApp.factory('Plans', [
  '$resource',
  function($resource) {
    return $resource(
      '/subscription/plans.json',
      {},
      {
        list: { method: 'GET' },
        create: { method: 'POST' },
        client_plans: {
          method: 'GET',
          url: 'subscription/plans/client_plans.json'
        },
        client_private_plans: {
          method: 'GET',
          url: 'subscription/plans/client_private_plans.json'
        }
      }
    );
  }
]);
