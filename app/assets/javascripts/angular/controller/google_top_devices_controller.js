clickxApp.controller('GoogleAnalyticsSocialTopDevices', [
  '$scope',
  '$rootScope',
  'GoogleAnalyticsService',
  '$interval',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    GoogleAnalyticsService,
    $interval,
    $mdDateRangePicker
  ) {
    'use strict';
    $scope.ga_tab = 'top_devices';
    $scope.ga_start_date = '30';
    $scope.size = window.innerWidth;
    var current_business = $rootScope.current_business;
    var devices = {
      desktop: 'Desktop/Laptop',
      mobile: 'Mobile',
      tablet: 'Tablet'
    };

    call_google_landing_analytic($rootScope.date);

    $scope.name = 'google_analytics_top_devices';

    $scope.load_datewise_analytics = function($event) {
      $mdDateRangePicker
        .show({
          model: $rootScope.selectedRange,
          autoConfirm: true,
          customTemplates: $rootScope.mdCustomTemplates,
          showTemplate: true,
          isDisabledDate: $rootScope.isFutureDate
        })
        .then(function(result) {
          if (result) {
            $rootScope.selectedRange = result;
            $rootScope.date = {
              startDate: moment(result.dateStart).format('YYYY-MM-DD'),
              endDate: moment(result.dateEnd).format('YYYY-MM-DD')
            };
            call_google_landing_analytic($rootScope.date);
          }
        });
    };

    function call_google_landing_analytic(dates) {
      var params = {
        start_date: dates.startDate,
        end_date: dates.endDate,
        graph_option: 'date'
      };
      GoogleAnalyticsService.landing_pages(current_business, params).then(
        function(result) {
          if (result.status == 200 && result.data) {
            if (result.data.status == 200 && result.data.data) {
              var device_pie_chart_data = {};
              if (result.data.data && result.data.data.chart_data) {
                var device_data = result.data.data.chart_data;
                device_pie_chart_data['series'] = [];
                var device_series_data = _.map(device_data, function(
                  value,
                  key
                ) {
                  var returnObject = {};
                  returnObject['name'] = devices[key] || null;
                  returnObject['y'] = value;
                  return returnObject;
                });
                device_pie_chart_data['series'].push({
                  name: 'Device Percentage',
                  colorByPoint: true,
                  data: device_series_data
                });
                GoogleAnalyticsService.plot_device_pie_chart(
                  '#device-percentage-chart',
                  device_pie_chart_data
                );
              }
            }
          }
        }
      );
    }
    $scope.resize = function() {
      $scope.size = window.innerWidth;
    };
    $interval($scope.resize, 100);
    $scope.$watch('size', function(newValue, oldValue) {
      if (newValue != oldValue) {
        $scope.resizeChart('device-percentage-chart');
      }
    });
  }
]);
