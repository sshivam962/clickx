clickxApp.directive('redraw', [
  '$window',
  '$timeout',
  '$interval',
  function($window, $timeout, $interval) {
    return {
      restrict: 'A',
      replace: true,
      template: '<div></div>',
      link: function(scope, element, attrs) {
        scope.$watch(attrs.config, function(value) {
          if (angular.isDefined(value)) {
            $interval(
              function() {
                $(element[0]).highcharts(value);
              },
              1000,
              50
            );
            angular.element($window).bind('resize', function() {
              $timeout(function() {
                $(element[0]).highcharts(value);
              }, 1000);
              scope.$digest();
            });
          }
        });
      }
    };
  }
]);
