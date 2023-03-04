clickxApp.controller('RankSummary', [
  '$scope',
  'Business',
  '$rootScope',
  '$routeParams',
  'params',
  '$mdDialog',
  function($scope, Business, $rootScope, $routeParams, params, $mdDialog) {
    $scope.range = params.rankRange;
    $scope.engine = $rootScope.searchEngine;
    $scope.propertyName = 'rank';
    $scope.reverse = false;

    var params = {
      id: $rootScope.business.id,
      duration: params.rankDuration,
      engine: $rootScope.searchEngine,
      date_clicked: params.rankDate,
      range: params.rankRange
    };

    Business.rank_summaries(
      params,
      function(success) {
        $scope.keywordDetails = success;
        $scope.export_pdf =
          '/businesses/' +
          $rootScope.current_business +
          '/rank_summaries.pdf?' +
          jQuery.param(params);
        $scope.csv_url =
          '/businesses/' +
          $rootScope.current_business +
          '/rank_summaries.csv?' +
          jQuery.param(params);
      },
      function(error) {}
    );

    $scope.sortBy = function(propertyName) {
      $scope.reverse =
        $scope.propertyName === propertyName ? !$scope.reverse : false;
      $scope.propertyName = propertyName;
    };

    $scope.cancel = function() {
      $mdDialog.cancel();
    };
  }
]);
