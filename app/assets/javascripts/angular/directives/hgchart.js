clickxApp.directive('hcPieChart', function() {
  return {
    restrict: 'EA',
    scope: {
      title: '=',
      data: '=data'
    },
    link: function(scope, element, attr) {
      scope.$watch(
        'data',
        function(newValue) {
          $(element).highcharts({
            colors: ['rgb(74, 172, 162)'],
            exporting: { enabled: false },
            title: {
              text: ''
            },
            chart: {
              width: 175,
              height: 50,
              backgroundColor: 'transparent'
            },
            xAxis: {
              categories: ['Max', 'Min'],
              visible: false,
              lineWidth: 0,
              tickWidth: 0,
              gridLineWidth: 0,
              title: {
                text: ''
              },
              labels: {
                enabled: false
              }
            },
            yAxis: {
              visible: false,
              gridLineWidth: 0,
              title: {
                text: ''
              },
              labels: {
                enabled: false
              }
            },
            tooltip: {
              formatter: function() {
                return this.x + ': <b>' + this.y + '</b>';
              }
            },
            legend: {
              enabled: false
            },
            series: [
              {
                data: [newValue.total - newValue.change, newValue.total]
              }
            ]
          });
          //
        },
        true
      );
    }
  };
});
