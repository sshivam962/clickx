clickxApp.controller('SiteAuditreadabilityCtrl', [
  '$scope',
  '$routeParams',
  'SiteAuditService',
  function($scope, $routeParams, SiteAuditService) {
    $scope.businessId = $routeParams.business_id;
    $scope.seoTabActive = 'siteReadability';
    $scope.rows_per_page = 25;
    $scope.readability = [];
    $scope.copy_readability = [];
    SiteAuditService.readability(
      { id: $scope.businessId },
      function(response) {
        $scope.readability = response.data.data;
        $scope.copy_readability = $scope.readability;
      },
      function(error) {
        toastr.warning(error.data.error);
      }
    );
  }
]);
