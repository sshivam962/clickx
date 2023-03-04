angular.module('clickxApp.Businesses', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/select', {
      templateUrl: 'themeX/businesses/select_business.html',
      title: 'Settings | __app_name__'
    });
  }
]);
