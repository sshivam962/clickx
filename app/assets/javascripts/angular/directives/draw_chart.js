/*
=============================================
=    Example  Highchart Directive    =
=============================================
Refer `HubDashBoard_controller.js` and `contacts_by_source.html.haml`

  In View:
    %draw-chart.btn-pointer{ 'config': 'chartConfig' }

  In Controller:
    $scope.chartConfig = {
      {
        title: {
            text: 'Solar Employment Growth by Sector, 2010-2016'
        },
        yAxis: {
            title: {
                text: 'Number of Employees'
            }
        },
        series: [{
            name: 'Installation',
            data: [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
        }, {
            name: 'Manufacturing',
            data: [24916, 24064, 29742, 29851, 32490, 30282, 38121, 40434]
        }]
      }
    };

==================Example=================
*/

clickxApp.directive('drawChart', [
  '$window',
  '$timeout',
  function ($window, $timeout) {
    return {
      restrict: 'E',
      replace: true,
      template: '<div></div>',
      scope: {
        config: '='
      },
      link: function (scope, element, attrs) {
        var config = scope.config;
        config.chart.events = {
          load: function (evt) {
            this.reflow();
          }
        };

        $(element[0]).highcharts(config);

        // Resize the chart element on Window Resizing
        angular
          .element($window)
          .bind('resize', function () {
            $timeout(function () {
              $(element[0]).highcharts(scope.config);
            }, 1000);
            scope.$digest();
          });

        scope.$watchCollection('config', function (newValue, oldValue) {
          if (newValue != oldValue)
            $(element[0]).highcharts(newValue);
        });
      }
    };
  }
]);
