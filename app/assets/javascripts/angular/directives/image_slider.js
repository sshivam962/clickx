clickxApp.directive('imageSlider', function() {
  return {
    restrict: 'EA',
    scope: {
      urlData: '=urlData',
      setUrlImage: '&setImageUrl'
    },
    controller: [
      '$scope',
      function ImageSliderController($scope) {
        $scope.currentIndex = 0;
        $scope.direction = 'left';

        $scope.setCurrent = function(index) {
          $scope.direction = index > $scope.currentIndex ? 'left' : 'right';
          $scope.currentIndex = index;
        };

        $scope.slides = [];

        angular.copy($scope.urlData.images, $scope.slides);
        $scope.setCurrent(0);

        $scope.isCurrent = function(index) {
          return $scope.currentIndex === index;
        };

        $scope.next = function() {
          $scope.direction = 'left';
          $scope.currentIndex =
            $scope.currentIndex < $scope.slides.length - 1
              ? ++$scope.currentIndex
              : 0;
        };

        $scope.prev = function() {
          $scope.direction = 'right';
          $scope.currentIndex =
            $scope.currentIndex > 0
              ? --$scope.currentIndex
              : $scope.slides.length - 1;
        };
      }
    ],
    templateUrl: 'directives/image_slider.html',
    link: function(scope, element, attrs) {
      scope.$watch('currentIndex', function(value, previousValue) {
        scope.setUrlImage({ selected_image: scope.slides[value]['src'] });
      });
    }
  };
});
