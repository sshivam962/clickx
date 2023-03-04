angular.module('clickxApp.SearchTerms', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/search_terms', {
      templateUrl: 'themeX/search_terms/index.html',
      controller: 'SearchTerm',
      title: 'Rep Management | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Rep Management', link: '/#/search_terms' }
        ]
      }
    });

    $routeProvider.when('/search_terms/:id/ranking_positions', {
      templateUrl: 'themeX/search_terms/ranking_positions.html',
      controller: 'RankingPositions',
      title: 'Rep Management | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Rep Management', link: '/#/search_terms' }
        ]
      }
    });
  }
]);
