clickxApp.factory('SearchTerms', [
  '$resource',
  function($resource) {
    return $resource(
      '/',
      {},
      {
        create_serach_term: { url: '/search_terms.json', method: 'POST' },
        search_terms: { url: '/search_terms.json', method: 'GET' },
        delete_search_term: {
          url: '/search_terms/:id.json',
          method: 'DELETE',
          params: { id: '@id' }
        },
        get_search_term: {
          url: '/search_terms/:id.json',
          method: 'GET',
          params: { id: '@id' }
        }
      }
    );
  }
]);
