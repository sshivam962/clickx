clickxApp.factory('FbAds', [
  '$resource',
  function($resource) {
    var url = '/fb_ads/pages.json';
    return $resource(
      url,
      {},
      {
        query: { method: 'GET', isArray: true },
        fb_account_status: {
          url: '/fb_ads/fb_account_status.json',
          method: 'GET'
        },
        fb_account_campaigns: {
          url: '/fb_ads/fb_account_campaigns.json',
          method: 'GET'
        },
        remove_facebook_ads: {
          url: '/fb_ads/facebook/:id.json',
          method: 'DELETE',
          params: { id: 'id' }
        },
        fb_ad_accounts: { url: '/fb_ads/facebook.json', method: 'GET' },
        create_account: { url: '/fb_ads/fb_ad_account.json', method: 'POST' },
        fb_all_campaigns: { url: '/fb_ads/all_campaigns.json', method: 'POST'},
        create_campaign: { url: '/fb_ads/create_campaign.json', method: 'POST'},
        campaigns: { url: '/fb_ads/campaigns.json', method: 'GET' },
        ads: { url: '/fb_ads/ads.json', method: 'GET' },
        adsets: { url: '/fb_ads/adsets.json', method: 'GET' },
        graph_data: { url: '/fb_ads/graph_data.json', method: 'GET' },
        update: {
          url: '/fb_ads/facebook/:id.json',
          method: 'PUT',
          params: { id: '@id' }
        },
        ad_preview: { url: '/fb_ads/ads/ad_preview.json', method: 'GET' },
        destroy: {
          url: '/fb_ads/facebook/:id',
          method: 'DELETE',
          params: { id: '@id' }
        }
      }
    );
  }
]);
