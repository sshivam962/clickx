clickxApp.directive('onLoadChart', [
  '$window',
  '$rootScope',
  function($window, $rootScope) {
    return {
      restrict: 'A',
      link: function($scope, element, attrs) {
        $rootScope.$on('cfpLoadingBar:completed', function() {
          try {
            var callChart = $('#' + attrs.id).highcharts();
            try {
              callChart.setSize(
                $('#' + attrs.id)
                  .parent()
                  .width()
              );
            } catch (e) {
              //console.log(e);
            }
          } catch (e) {
            //console.log(e)
          }
        });
      }
    };
  }
]);
