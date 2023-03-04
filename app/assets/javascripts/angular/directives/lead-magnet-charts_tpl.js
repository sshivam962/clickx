clickxApp.directive('leadMagnetAreaChart', [
  '$timeout',
  function($timeout) {
    return {
      restrict: 'EAC',
      replace: true,
      scope: {
        chartData: '='
      },
      template: '<div class="lead-magnet-chart"></div>',
      link: function(scope, element, attr) {
        scope.$watch('chartData', function(newData, oldData) {
          if (typeof newData != 'undefined' && _.isObject(newData)) {
            $timeout(function() {
              var width = $(element).width();
              if (newData && newData.chart && !newData.chart.width) {
                newData['chart']['width'] = width;
              }
              $(element).highcharts(newData);
              $timeout(function() {
                var chartData = $(element).highcharts();
                width = $(element).width();
                chartData.setSize(width);
              }, 200);
            }, 100);
          }
        });
      }
    };
  }
]);
