clickxApp.controller('VideosAcademy', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  '$location',
  '$routeParams',
  '$window',
  'Videos',
  'Video',
  '$sce',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    $location,
    $routeParams,
    $window,
    Videos,
    Video,
    $sce
  ) {
    $rootScope.current_controller = 'academy';
    $scope.selected_category = 'All';
    $scope.view = 'grid';

    Videos.categories_list({}, function(response) {
      $scope.categories = response;
      $scope.categories.unshift('All');
    });

    $scope.get_academy_videos = function(category) {
      Videos.academy({ category: category }, function(response) {
        $scope.videos = response;
        $scope.selected_category = category;
      });
    };
    $scope.get_academy_videos($scope.selected_category);

    $scope.renderHtml = function(htmlCode) {
      return $sce.trustAsHtml(htmlCode);
    };

    $scope.go_back = function() {
      $window.history.back();
    };
  }
]);
