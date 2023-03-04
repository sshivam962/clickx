clickxApp.directive('clearDateRange', [
  '$compile',
  function($compile) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        scope.$watch('initial', function(newValue) {
          if (!newValue) {
            while (element.firstChild) {
              element.removeChild(element.firstChild);
            }

            var contentTr = angular.element(
              '<button type="button" ' +
                ' class="md-raised md-default md-button clear-date-range" ' +
                ' aria-label="Close" ng-click="clearDateRange();" ' +
                ' ><span aria-hidden="true">clear ' +
                ' </span></button> '
            );
            contentTr.insertAfter(element);
            $compile(contentTr)(scope);
          } else {
            angular.element('.clear-date-range').remove();
          }
        });
      }
    };
  }
]);
