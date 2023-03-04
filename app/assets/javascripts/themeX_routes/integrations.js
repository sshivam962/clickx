angular.module('clickxApp.Integrations', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/integrations', {
      templateUrl: 'themeX/integrations/integrations.html',
      controller: 'Integrations',
      title: 'Integrations | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Integrations', link: '/#/integrations' }
        ]
      }
    });
  }
]);
