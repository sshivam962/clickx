clickxApp.controller('SettingsBudget', [
  '$scope',
  '$rootScope',
  'Business',
  function($scope, $rootScope, Business) {
    $scope.budget = {};
    $scope.budget.ppc_budget = current_ppc_budget;
    $scope.budget.fb_budget = current_fb_budget;
    $scope.ppc_service = current_ppc_service;
    $scope.facebook_ad_service = current_facebook_ad_service;
    $scope.current_template = 'themeX/settings/budget_pacing.html';
    $scope.settings_tab = 'budget_pacing';

    $scope.setBudget = function() {
      Business.set_budget(
        {
          id: $rootScope.current_business,
          budget: $scope.budget
        },
        function(response) {
          if (response.status == 200) {
            current_ppc_budget = response.data.ppc_budget;
            toastr.success(response.message);
          } else {
            toastr.error(response.message);
          }
        }
      );
    };
  }
]);
