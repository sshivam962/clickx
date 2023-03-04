clickxApp.factory('Agencies', [
  '$resource',
  function($resource) {
    return $resource(
      '/agencies.json',
      {},
      {
        query: { isArray: false },
        get: { method: 'GET', isArray: true },
        get_businesses: {
          url: '/agencies/get_businesses.json',
          method: 'GET',
          params: {
            agency_id: '@agency_id',
            start_period: '@start_period',
            end_period: '@end_period',
            filter: '@filter'
          }
        },
        get_users: {
          url: '/agencies/get_users.json',
          method: 'GET',
          params: { agency_id: '@agency_id' }
        },
        agency_admins: {
          url: '/agencies/agency_admins.json',
          method: 'GET',
          params: { agency_id: '@agency_id' },
          isArray: true
        },
        create: { method: 'POST' }
      }
    );
  }
]);

clickxApp.factory('Agency', [
  '$resource',
  function($resource) {
    return $resource(
      '/agencies/:id.json',
      {},
      {
        show: { method: 'GET' },
        update: { method: 'PUT', params: { id: '@id' } },
        delete: { method: 'DELETE', params: { id: '@id' } },
        add_client: {
          url: '/agencies/:id/add_client',
          method: 'POST',
          params: { id: '@id' }
        },
        update_client: {
          url: '/agencies/update_client',
          method: 'POST',
          params: { id: '@id', business_id: '@business_id' }
        },
        update_client: {
          url: '/agencies/update_client',
          method: 'POST',
          params: { business_id: '@business_id' }
        },
        add_keywords: {
          url: '/agencies/add_keywords',
          method: 'POST',
          params: { business_id: '@business_id' }
        },
        destroy_client: {
          url: '/agencies/destroy_client',
          method: 'DELETE',
          params: { business_id: '@business_id' }
        },
        client_questionnaires: {
          url: '/agencies/client_questionnaires',
          method: 'GET',
          params: { business_id: '@business_id' }
        },
        get_agency_limits: {
          url: '/agencies/get_agency_limits',
          method: 'GET',
          params: { id: '@id', business_id: '@business_id' }
        },
        current_plan: { url: '/agencies_billing/current_plan', method: 'GET' },
        fetch_cards: { url: '/agencies_billing/fetch_cards', method: 'GET' },
        update_card: { url: '/agencies_billing/update_card', method: 'POST' },
        subscribe: { url: '/agencies_billing/subscribe', method: 'POST' },
        subscribe_package: {
          url: '/agencies_billing/subscribe_package',
          method: 'POST'
        },
        package_plans: {
          url: '/agencies_billing/package_plans',
          method: 'GET'
        },
        verify_cname: {
          url: '/agencies/:id/verify_cname.json',
          method: 'PATCH',
          params: { id: '@id' }
        }
      }
    );
  }
]);
