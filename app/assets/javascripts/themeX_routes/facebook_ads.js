angular.module('clickxApp.FacebookAds', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/facebook_ads', {
      templateUrl: 'themeX/facebook_ads/facebook_ads.html',
      controller: 'FbAdsCampaigns',
      title: ' Facebook Ads',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Facebook Ads', link: '/#/facebook_ads' }
        ]
      }
    });
    $routeProvider.when('/facebook_ads/ads', {
      templateUrl: 'themeX/facebook_ads/facebook_ads.html',
      controller: 'FbAdsDetail',
      title: ' Facebook Ads',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Facebook Ads/Ads', link: '/#/facebook_ads/ads' }
        ]
      }
    });
    $routeProvider.when('/facebook_ads/adsets', {
      templateUrl: 'themeX/facebook_ads/facebook_ads.html',
      controller: 'FbAdsets',
      title: ' Facebook Ads',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Facebook Ads/Adsets', link: '/#/facebook_ads/adsets' }
        ]
      }
    });
  }
]);
