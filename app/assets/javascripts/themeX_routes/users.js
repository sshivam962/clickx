angular.module('clickxApp.Users', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/users', {
      templateUrl: 'themeX/users/users.html',
      controller: 'ManageBizUsers',
      title: 'Manage Business Users | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'User Management', link: '/#/{{business_id}}/users' }
        ]
      }
    });
    $routeProvider.when('/:id/invite_user', {
      templateUrl: 'themeX/users/invite_user.html',
      controller: 'UserInvite',
      title: 'Invite User | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Invite New User', link: '/#/{{business_id}}/invite_user' }
        ]
      }
    });
  }
]);
