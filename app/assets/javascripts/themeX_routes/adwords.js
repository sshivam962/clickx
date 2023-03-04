angular.module('clickxApp.Adwords', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/adwords', {
      templateUrl: 'themeX/adwords/adwords.html',
      controller: 'AdwordSummary',
      title: ' Ad Summary | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'PPC Reports', link: '/#/adwords' }
        ]
      }
    });
    $routeProvider.when('/adwords/keyword', {
      templateUrl: 'themeX/adwords/adwords.html',
      controller: 'AdwordKeyword',
      title: 'Ad Keyword | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'PPC Reports', link: '/#/adwords/' },
          { name: 'Keywords', link: '/#/adwords/keyword' }
        ]
      }
    });
    $routeProvider.when('/adwords/ads', {
      templateUrl: 'themeX/adwords/adwords.html',
      controller: 'AdwordAds',
      title: 'Ad Ads | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'PPC Reports', link: '/#/adwords' },
          { name: 'Ads', link: '/#/adwords/ads' }
        ]
      }
    });
    $routeProvider.when('/adwords/queries', {
      templateUrl: 'themeX/adwords/adwords.html',
      controller: 'AdwordQueries',
      title: 'Ad Queries | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'PPC Reports', link: '/#/adwords' },
          { name: 'Search Terms', link: '/#/adwords/queries' }
        ]
      }
    });
    $routeProvider.when('/adwords/campaigns', {
      templateUrl: 'themeX/adwords/adwords.html',
      controller: 'AdwordCampaigns',
      title: 'Ad Campaigns | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'PPC Reports', link: '/#/adwords' },
          { name: 'Campaigns', link: '/#/adwords/campaigns' }
        ]
      }
    });
    $routeProvider.when('/:business_id/:service/select_accounts', {
      templateUrl: 'themeX/adwords/select_accounts.html',
      controller: 'AdwordSelectAccountsController',
      title: 'Ad Accounts | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Integrations', link: '/#/integrations' },
          { name: 'Select Accounts', link: '/' }
        ]
      }
    });
  }
]);
