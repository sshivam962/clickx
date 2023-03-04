clickxApp.factory('Locations', [
  '$resource',
  function($resource) {
    return $resource(
      '/locations.json',
      {},
      {
        get_all_locations: {
          url: '/locations/get_all_locations.json',
          method: 'GET',
          isArray: true
        },
        query: { method: 'GET', isArray: true },
        create: { method: 'POST' },
        business_day: {
          url: '/locations/business_hour',
          method: 'POST',
          params: { working_days: '@working_days' }
        },
        for_local_profile: {
          url: '/local_profile_locations.json',
          method: 'GET',
          isArray: true,
          params: { business_id: '@id' }
        },
        brightlocal_locations: {
          url: 'locations/brightlocal_locations.json',
          method: 'GET',
          isArray: true,
          params: { business_id: '@id' }
        },
        locations_with_average_rating: {
          url: '/locations/locations_with_average_rating.json',
          method: 'GET',
          isArray: true,
          params: { business_id: '@id' }
        },
        business_locations: {
          url: '/businesses/:id/locations.json',
          method: 'GET',
          params: { business_id: '@id' }
        }
      }
    );
  }
]);

clickxApp.factory('Location', [
  '$resource',
  function($resource) {
    return $resource(
      '/locations/:id.json',
      {},
      {
        show: { method: 'GET' },
        update: { method: 'PUT', params: { id: '@id' } },
        delete: { method: 'DELETE', params: { id: '@id' } },
        get_service_location: {
          url: '/get_service_location.json ',
          method: 'GET',
          params: { id: '@id' }
        },
        get_yext_listings: {
          url: '/locations/:id/yext_listings.json ',
          method: 'GET',
          params: { id: '@id' }
        },
        set_yext_id: {
          url: '/locations/:id/set_yext_id.json',
          method: 'PUT',
          params: { id: '@id', yext_id: '@yext_store_id' }
        },
        set_brightlocal_id: {
          url: '/locations/:id/set_brightlocal_id.json',
          method: 'PUT',
          params: { id: '@id', brightlocal_id: '@brightlocal_id' }
        },
        reviews: {
          url: '/locations/:id/reviews.json',
          method: 'GET',
          params: { id: '@id' }
        },
        sitewise_reviews: {
          url: '/locations/:id/sitewise_reviews.json',
          method: 'GET',
          params: { id: '@id' }
        },
        star_counts: {
          url: '/locations/:id/star_counts.json',
          method: 'GET',
          params: { id: '@id' }
        },
        reviews_count: {
          url: '/locations/:id/reviews_count.json',
          method: 'GET',
          params: { id: '@id' }
        },
        reviews_growth: {
          url: '/locations/:id/reviews_growth.json',
          method: 'GET',
          params: { id: '@id' }
        },
        dir_reviews: {
          url: '/locations/:id/dir_reviews.json',
          method: 'GET',
          params: { id: '@id', dir: '@dir' }
        },
        reviews_by_stars: {
          url: '/locations/:id/reviews_by_stars.json',
          method: 'GET',
          params: { id: '@id', star_count: '@star_count' }
        },
        set_bright_local_campaign_id: {
          url: '/locations/:id/set_bright_local_campaign_id.json',
          method: 'PUT',
          params: {
            id: '@id',
            bright_local_campaign_id: '@bright_local_campaign_id'
          }
        },
        get_bright_local_listing: {
          url: '/locations/:id/bright_local_listings.json ',
          method: 'GET',
          params: { id: '@id' }
        },
        get_yext_info: {
          url: '/locations/:id/yext_info.json ',
          method: 'GET',
          params: { id: '@id' }
        },
        get_powerlisting: {
          url: '/locations/:id/scan/:site_id.json ',
          method: 'GET',
          params: { id: '@id', site_id: '@site_id', ignoreLoadingBar: true }
        }
      }
    );
  }
]);
