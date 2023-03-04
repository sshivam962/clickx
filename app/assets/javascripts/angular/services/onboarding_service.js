clickxApp.factory('Onboarding', [
  '$resource',
  function($resource) {
    return $resource(
      '/onboarding_procedures.json',
      {},
      {
        create: { method: 'POST' },
        query: { method: 'GET' },
        assigned: { method: 'GET', url: 'onboarding_procedures/assigned' },
        get: {
          method: 'GET',
          url: 'onboarding_procedures/:id',
          params: { id: '@id' }
        },
        update: {
          method: 'PATCH',
          url: 'onboarding_procedures/:id',
          params: { id: '@id' }
        },
        delete: {
          method: 'DELETE',
          url: 'onboarding_procedures/:id',
          params: { id: '@id' }
        },
        toggle_status: {
          method: 'POST',
          url: '/onboarding_tasks/:id/toggle_status',
          params: { id: '@id' }
        }
      }
    );
  }
]);
