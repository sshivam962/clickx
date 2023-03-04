clickxApp.controller('SetGoalsFunnelAnalytics', [
  '$scope',
  '$rootScope',
  '$routeParams',
  '$mdDialog',
  'Business',
  '$timeout',
  function($scope, $rootScope, $routeParams, $mdDialog, Business, $timeout) {
    Business.marketing_performance_goal(
      { business_id: $routeParams.business_id },
      function(response) {
        $scope.goal_present = true;
        $scope.visits = response.visits_per_month;
        $scope.contacts = response.contacts_per_month;
        $scope.customers = response.customers_per_month;
      },
      function(error) {
        $scope.goal_present = false;
        $scope.visits = 5000;
        $scope.contacts = 200;
        $scope.customers = 20;
      }
    );
    $scope.getPercentage = function(x, y) {
      if (!(_.isNumber(x) && _.isNumber(y))) return '--';
      else return (y / x) * 100;
    };
    $scope.setMarketingGoals = function(visits, contacts, customers) {
      $timeout(function() {
        if ($scope.goal_present) {
          Business.update_marketing_performance_goal(
            {
              business_id: $routeParams.business_id,
              visits_per_month: visits,
              contacts_per_month: contacts,
              customers_per_month: customers
            },
            function(response) {
              $scope.visits = response.visits_per_month;
              $scope.contacts = response.contacts_per_month;
              $scope.customers = response.customers_per_month;
            }
          );
        } else {
          Business.set_marketing_performance_goal(
            {
              business_id: $routeParams.business_id,
              visits_per_month: visits,
              contacts_per_month: contacts,
              customers_per_month: customers
            },
            function(response) {
              $scope.visits = response.visits_per_month;
              $scope.contacts = response.contacts_per_month;
              $scope.customers = response.customers_per_month;
            }
          );
        }
        $mdDialog.cancel();
      });
    };
    $scope.cancel = function() {
      $mdDialog.cancel();
    };
    $scope.removeGoal = function() {
      Business.reset_marketing_performance_goal(
        {
          business_id: $routeParams.business_id,
          user: current_user_name
        },
        function() {}
      );
      $mdDialog.cancel();
    };
  }
]);
