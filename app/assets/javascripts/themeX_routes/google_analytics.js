angular.module('clickxApp.GoogleAnalytics', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/google_analytics', {
      templateUrl: 'themeX/google_analytics/google_analytics.html',
      controller: 'GoogleAnalyticsOverview',
      title: 'Google Analytic Overview | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Google Analytics', link: '/#/google_analytics' }
        ]
      }
    });
    $routeProvider.when('/google_analytics/keywords', {
      templateUrl: 'themeX/google_analytics/google_analytics.html',
      controller: 'GoogleAnalyticsSearches',
      title: 'Google Analytic Searches | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Google Analytics', link: '/#/google_analytics' },
          { name: 'Keywords', link: '/#/google_analytics/keywords' }
        ]
      }
    });
    $routeProvider.when('/google_analytics/top_pages', {
      templateUrl: 'themeX/google_analytics/google_analytics.html',
      controller: 'GoogleAnalyticsSocialNewLandingPages',
      title: 'Google landing page | __app_name__ : Google Analytics',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Google Analytics', link: '/#/google_analytics' },
          { name: 'Top Pages', link: '/#/google_analytics/top_pages' }
        ]
      }
    });
    $routeProvider.when('/google_analytics/referrals', {
      templateUrl: 'themeX/google_analytics/google_analytics.html',
      controller: 'GoogleAnalyticsReferrals',
      title: 'Google Analytic Referrals | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Google Analytics', link: '/#/google_analytics' },
          { name: 'Referrals', link: '/#/google_analytics/referrals' }
        ]
      }
    });
    $routeProvider.when('/google_analytics/campaigns', {
      templateUrl: 'themeX/google_analytics/google_analytics.html',
      controller: 'GoogleAnalyticsAcquisitionCampaigns',
      title: 'Acquisition Campaigns | __app_name__ : Google Analytics',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Google Analytics', link: '/#/google_analytics' },
          { name: 'Campaigns', link: '/#/google_analytics/campaigns' }
        ]
      }
    });
    $routeProvider.when('/google_analytics/source_medium', {
      templateUrl: 'themeX/google_analytics/google_analytics.html',
      controller: 'GoogleAnalyticsSourceMedium',
      title: 'Source Medium | __app_name__ : Google Analytics',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Google Analytics', link: '/#/google_analytics' },
          { name: 'Source Medium', link: '/#/google_analytics/source_medium' }
        ]
      }
    });

    $routeProvider.when('/google_analytics/locales', {
      templateUrl: 'themeX/google_analytics/google_analytics.html',
      controller: 'GoogleAnalyticsLocales',
      title: 'Google Analytic Locales | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Google Analytics', link: '/#/google_analytics' },
          { name: 'Locales', link: '/#/google_analytics/locales' }
        ]
      }
    });
    // $routeProvider.when('/google_analytics/goals', {
    //   templateUrl: 'themeX/google_analytics/google_analytics.html',
    //   controller: 'GoogleAnalyticsGoals',
    //   title: 'Google Analytic Goals | __app_name__',
    //   breadcrumb: {
    //     links: [
    //       { name: 'Home', link: '/b/dashboard' },
    //       { name: 'Google Analytics', link: '/#/google_analytics' },
    //       { name: 'Goals', link: '/#/google_analytics/goals' }
    //     ]
    //   }
    // });
    // $routeProvider.when('/google_analytics/network', {
    //   templateUrl: 'themeX/google_analytics/google_analytics.html',
    //   controller: 'GoogleAnalyticsSocialNetworkReferral',
    //   title: 'Google Analytics Social Network',
    //   breadcrumb: {
    //     links: [
    //       { name: 'Home', link: '/b/dashboard' },
    //       { name: 'Google Analytics', link: '/#/google_analytics' },
    //       { name: 'Social', link: '/#/google_analytics/network' }
    //     ]
    //   }
    // });
    // $routeProvider.when('/google_analytics/landing_pages', {
    //   templateUrl: 'themeX/google_analytics/google_analytics.html',
    //   controller: 'GoogleAnalyticsSocialLandingPages',
    //   title: 'Google landing page | __app_name__ : Google analytic page',
    //   breadcrumb: {
    //     links: [
    //       { name: 'Home', link: '/b/dashboard' },
    //       { name: 'Google Analytics', link: '/#/google_analytics' },
    //       { name: 'Shared URLs', link: '/#/google_analytics/landing_pages' }
    //     ]
    //   }
    // });
    // $routeProvider.when('/google_analytics/top_devices', {
    //   templateUrl: 'themeX/google_analytics/google_analytics.html',
    //   controller: 'GoogleAnalyticsSocialTopDevices',
    //   title: 'Google Top Devices | __app_name__',
    //   breadcrumb: {
    //     links: [
    //       { name: 'Home', link: '/b/dashboard' },
    //       { name: 'Google Analytics', link: '/#/google_analytics' },
    //       { name: 'Top Devices', link: '/#/google_analytics/top_devices' }
    //     ]
    //   }
    // });
  }
]);
