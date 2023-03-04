clickxApp.controller('SettingsContentOrdering', [
  '$scope',
  '$rootScope',
  '$route',
  'ContentOrder',
  function($scope, $rootScope, $route, ContentOrder) {
    $scope.current_template = 'themeX/settings/content_ordering.html';
    $scope.settings_tab = 'content_ordering';

    ContentOrder.content_order_default_show(
      {
        business_id: $rootScope.current_business
      },
      function(result) {
        if (result.status == 200) {
          $scope.default_content = $.extend(
            $scope.default_content,
            result.data
          );
        }
      },
      function(error) {}
    );

    $scope.saveDefaultContentValue = function(e) {
      e.preventDefault();
      var params_to_pass = $scope.default_content;
      params_to_pass = $.extend(params_to_pass, {
        business_id: $rootScope.current_business
      });
      if (!$scope.default_content.id) {
        ContentOrder.content_order_default(
          params_to_pass,
          function(result) {
            if (result.status == 201) {
              toastr.success(result.message);
              $route.reload();
            } else {
              toastr.error(result.message);
            }
          },
          function(error) {}
        );
      } else {
        ContentOrder.content_order_default_update(
          {
            id: $scope.default_content.id
          },
          _.omit(params_to_pass, 'id'),
          function(result) {
            if (result.status == 201 || result.status == 200) {
              toastr.success(result.message);
              $route.reload();
            } else {
              toastr.error(result.message);
            }
          },
          function(error) {}
        );
      }
    };
  }
]);
