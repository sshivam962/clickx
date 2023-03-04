clickxApp.factory('GoogleAnalytics', [
  '$resource',
  function($resource) {
    return $resource(
      '/custom_urls.json',
      {},
      {
        overview: {
          url: '/b/google_analytics/overview.json',
          method: 'GET',
          params: { id: '@id' },
        },
        overview_charts: {
          url: '/b/google_analytics/overview_charts.json',
          method: 'GET',
          params: { id: '@id' },
        },
        searches: {
          url: '/b/google_analytics/keywords.json',
          method: 'GET',
          params: { id: '@id' },
        },
        top_pages: {
          url: '/b/google_analytics/top_pages.json',
          method: 'GET',
          params: { id: '@id' },
        },
        referrals: {
          url: '/b/google_analytics/referrals.json',
          method: 'GET',
          params: { id: '@id' },
        },
        locales: {
          url: '/b/google_analytics/locales.json',
          method: 'GET',
          params: { id: '@id' },
        },
        campaigns: {
          url: '/b/google_analytics/campaigns.json',
          method: 'GET',
          params: { id: '@id' },
        },
        source_medium: {
          url: '/b/google_analytics/source_medium.json',
          method: 'GET',
          params: { id: '@id' },
        },
      }
    );
  }
]);
