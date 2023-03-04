clickxApp.controller('GoogleAnalyticsReferrals', [
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
    $scope.ga_tab = 'referrals';
    $scope.size = window.innerWidth;
    $scope.filterBy = 'date';
    $scope.toggleFilterBy = function(param) {
      $scope.filterBy = param;
      get_business_analytics(
        $rootScope.date.startDate,
        $rootScope.date.endDate
      );
    };

    get_business_analytics($rootScope.date.startDate, $rootScope.date.endDate);

    $scope.name = 'google_analytics_referrals';

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
        end_date: end_date,
        chart_type: 'default',
        graph_option: $scope.filterBy
      };
      $cookieStore.put('current_page', window.location.href);
      $scope.export_pdf =
        '/businesses/' +
        $rootScope.current_business +
        '/google_analytics_exports/referrals.pdf?' +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.referrals(params, function(
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
            $scope.referrals = response.data.referrals;
            _.each($scope.referrals, function(row) {
              row.totalUsers = parseInt(row.totalUsers);
              row.sessions = parseInt(row.sessions);
              row.screenPageViews = parseInt(row.screenPageViews);
              row.screenPageViewsPerSession = parseFloat(
                row.screenPageViewsPerSession
              ).toFixed(2);
              row.averageSessionDuration = new Date(0, 0, 0).setSeconds(row.averageSessionDuration);
              row.bounceRate = parseFloat(row.bounceRate * 100).toFixed(2);
            });
            $scope.copy_referrals = response.data.referrals;

            // $scope.total_stats = response.data.chart_data.totalsForAllResults;
            // users_data = GoogleCharts.users_chart(
            //   response.data.chart_data.chart_rows
            // );
            // $scope.referrals = function() {
            //   $timeout(function() {
            //     $('#visits_chart').highcharts(users_data[0]);
            //     $scope.resizeChart('visits_chart');
            //     $('#visitors_chart').highcharts(users_data[1]);
            //     $scope.resizeChart('visitors_chart');
            //     $('#new_visits_chart').highcharts(users_data[2]);
            //     $scope.resizeChart('new_visits_chart');
            //     $('#bounce_chart').highcharts(users_data[3]);
            //     $scope.resizeChart('bounce_chart');
            //     $('#avg_session_chart').highcharts(users_data[4]);
            //     $scope.resizeChart('avg_session_chart');
            //     $('#page_per_visit_chart').highcharts(users_data[5]);
            //     $scope.resizeChart('page_per_visit_chart');
            //   }, 10);
            // };
            // $scope.referrals();
            // $scope.resize = function() {
            //   $scope.size = window.innerWidth;
            // };
            // $interval($scope.resize, 100);
            // $scope.$watch('size', function(newValue, oldValue) {
            //   if (newValue != oldValue) {
            //     $scope.resizeChart('visits_chart');
            //     $scope.resizeChart('visitors_chart');
            //     $scope.resizeChart('new_visits_chart');
            //     $scope.resizeChart('bounce_chart');
            //     $scope.resizeChart('avg_session_chart');
            //     $scope.resizeChart('page_per_visit_chart');
            //   }
            // });
          }
        }
      });
    }
  }
]);
