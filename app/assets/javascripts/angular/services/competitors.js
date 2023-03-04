clickxApp.factory('Competition', [
  '$resource',
  '$http',
  '$rootScope',
  function($resource, $http, $rootScope) {
    return $resource(
      '',
      {},
      {
        add_competition: { url: '/competitions', method: 'POST' },
        competition: {
          url: '/competitions/business_competitions.json',
          method: 'GET',
          params: { business_id: '@business_id' }
        },

        competition_details: {
          url: '/competitions/:id.json',
          method: 'GET',
          params: { id: '@id' }
        },

        competition_rank_details: {
          url: '/competitions/:id/competition_keywords.json',
          method: 'GET',
          isArray: true,
          params: { id: '@id' }
        },

        competitors_history: {
          url: '/competitions/:id/competitors_history.json',
          method: 'GET',
          params: { id: '@id' }
        },

        competition_delete: { url: '/competitions/:id.json', method: 'DELETE' },

        potential_competitors: {
          url: 'businesses/:id/competitions/potential_competitors.json',
          method: 'GET'
        },

        common_backlinks: {
          url: 'businesses/:id/competitions/common_backlinks.json',
          method: 'GET',
          isArray: 'false'
        }
      }
    );
  }
]);
