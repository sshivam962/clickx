angular.module('clickxApp.Questionnaire', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/:business_id/questionnaire', {
      templateUrl: 'themeX/questionnaire/index.html',
      controller: 'QuestionnaireNew',
      title: 'New Questionnaire | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          {
            name: 'Campaign Intelligence',
            link: '/#/{{business_id}}/questionnaire'
          }
        ]
      }
    });
  }
]);
