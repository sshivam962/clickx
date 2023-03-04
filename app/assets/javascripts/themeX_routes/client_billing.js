angular.module('clickxApp.ClientBilling', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/billing', {
      templateUrl: 'themeX/client_billing/info.html',
      controller: 'BillingInfo',
      title: 'Billing',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Billing', link: '/#/{{business_id}}/billing' }
        ]
      }
    });
  }
]);
