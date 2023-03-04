clickxApp.directive('ngResize', [
  '$window',
  function($window) {
    return {
      scope: {
        ngResize: '='
      },
      link: function($scope, element, attrs) {
        angular.element($window).on('resize', function() {
          $scope.ngResize = window.innerWidth;
          $scope.$apply();
        });
      }
    };
  }
]);
