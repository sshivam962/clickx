angular.module('clickxApp.OnboardingProcedures', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/onboarding_procedures', {
      templateUrl: 'themeX/onboarding_procedures/index.html',
      controller: 'BusinessOnboardingProcedures',
      title: 'Onboarding Procedures | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Onboarding', link: '/#/onboarding_procedures' }
        ]
      }
    });
  }
]);
