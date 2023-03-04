clickxApp.directive('sticky', [
  '$window',
  function($window) {
    return {
      restrict: 'AE',
      link: function($scope, element, attrs) {
        angular.element($window).on('scroll', function() {
          if ($window.pageYOffset >= element[0].offsetTop) {
            element.addClass('sticky');
          } else {
            element.removeClass('sticky');
          }
        });
      }
    };
  }
]);
