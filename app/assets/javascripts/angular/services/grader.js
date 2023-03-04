clickxApp.factory('GraderInfo', [
  '$resource',
  function($resource) {
    return $resource(
      '/',
      {},
      {
        mobile_insights: { url: '/mobile_insights.json', method: 'GET' },
        desktop_insights: { url: '/desktop_insights.json', method: 'GET' },
        landing_page_info: { url: '/landing_page_info.json', method: 'GET' },
        backlinks_info: { url: '/backlinks_info.json', method: 'GET' },
        competitors_organic: {
          url: '/competitors_organic.json',
          method: 'GET'
        },
        competitors_adwords: { url: '/competitors_adwords.json', method: 'GET' }
      }
    );
  }
]);
