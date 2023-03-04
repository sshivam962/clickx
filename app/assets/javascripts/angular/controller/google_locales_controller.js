clickxApp.controller('GoogleAnalyticsLocales', [
  '$scope',
  '$rootScope',
  'GoogleAnalytics',
  '$location',
  'GoogleCharts',
  '$cookieStore',
  '$timeout',
  '$interval',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    GoogleAnalytics,
    $location,
    GoogleCharts,
    $cookieStore,
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'locales';
    $scope.size = window.innerWidth;

    get_business_analytics($rootScope.date.startDate, $rootScope.date.endDate);

    $scope.name = 'google_analytics_locales';

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
            get_business_analytics(
              $rootScope.date.startDate,
              $rootScope.date.endDate
            );
          }
        });
    };

    function get_business_analytics(start_date, end_date) {
      var params = {
        id: $rootScope.current_business,
        start_date: start_date,
        end_date: end_date
      };
      $cookieStore.put('current_page', window.location.href);
      $scope.export_pdf =
        '/businesses/' +
        $rootScope.current_business +
        '/google_analytics_exports/locales.pdf?' +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.locales(params, function(
        response
      ) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            $rootScope.flash = {};
            $rootScope.flash.message = response.errors;
            window.location.href = '/b/dashboard'
          } else {
            $scope.ga_sites = response.data.locales_stats;
            _.each($scope.ga_sites, function(row) {
              row.totalUsers = parseInt(row.totalUsers);
              row.sessions = parseInt(row.sessions);
              row.screenPageViewsPerSession = parseFloat(
                row.screenPageViewsPerSession
              ).toFixed(2);
              row.averageSessionDuration = new Date(0, 0, 0).setSeconds(row.averageSessionDuration);
              row.bounceRate = parseFloat(row.bounceRate * 100).toFixed(2);
            });
            $scope.copy_ga_sites = response.data.locales_stats;

            // map_data = $scope.copy_ga_sites;
            // $('#visitors_map').highcharts(
            //   'Map',
            //   GoogleCharts.users_map(map_data, 1)
            // );
            // $scope.resizeChart('visitors_map');
            // $scope.locales = function() {
            //   $timeout(function() {
            //     $('#visitors_map').highcharts(
            //       'Map',
            //       GoogleCharts.users_map(map_data, 1)
            //     );
            //     $scope.resizeChart('visitors_map');
            //     $('#page_per_visit_map').highcharts(
            //       'Map',
            //       GoogleCharts.users_map(map_data, 5)
            //     );
            //     $scope.resizeChart('page_per_visit_map');
            //     $('#avg_session_map').highcharts(
            //       'Map',
            //       GoogleCharts.users_map(map_data, 4)
            //     );
            //     $scope.resizeChart('avg_session_map');
            //     $('#new_visits_map').highcharts(
            //       'Map',
            //       GoogleCharts.users_map(map_data, 2)
            //     );
            //     $scope.resizeChart('new_visits_map');
            //     $('#bounce_map').highcharts(
            //       'Map',
            //       GoogleCharts.users_map(map_data, 3)
            //     );
            //     $scope.resizeChart('bounce_map');
            //   }, 10);
            // };
            // $scope.resize = function() {
            //   $scope.size = window.innerWidth;
            // };
            // $interval($scope.resize, 100);
            // $scope.$watch('size', function(newValue, oldValue) {
            //   if (newValue != oldValue) {
            //     $scope.resizeChart('visitors_map');
            //     $scope.resizeChart('page_per_visit_map');
            //     $scope.resizeChart('avg_session_map');
            //     $scope.resizeChart('new_visits_map');
            //     $scope.resizeChart('bounce_map');
            //   }
            // });
          }
        }
      });
    }
  }
]);
