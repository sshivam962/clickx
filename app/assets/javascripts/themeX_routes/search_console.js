angular.module('clickxApp.SearchConsole', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/:business_id/search_console/queries', {
      templateUrl: 'themeX/search_console/search_console.html',
      controller: 'GoogleSearchConsole',
      title: 'Google Search Console | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          {
            name: 'Search Console',
            link: '/#/{{business_id}}/search_console/queries'
          },
          {
            name: 'Top Queries',
            link: '/#/{{business_id}}/search_console/queries'
          }
        ]
      }
    });
    $routeProvider.when('/:business_id/search_console/pages', {
      templateUrl: 'themeX/search_console/search_console.html',
      controller: 'GoogleSearchConsolePages',
      title: 'Google Search Console Pages | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          {
            name: 'Search Console',
            link: '/#/{{business_id}}/search_console/queries'
          },
          { name: 'Top Pages', link: '/#/{{business_id}}/search_console/pages' }
        ]
      }
    });
    $routeProvider.when('/:business_id/sitemaps', {
      templateUrl: 'themeX/search_console/search_console.html',
      controller: 'GoogleSitemaps',
      title: 'Google Sitemaps | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          {
            name: 'Search Console',
            link: '/#/{{business_id}}/search_console/queries'
          },
          { name: 'Sitemaps', link: '/#/{{business_id}}/sitemaps' }
        ]
      }
    });
  }
]);
