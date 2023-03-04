clickxApp.controller('GoogleAnalyticsGoals', [
  '$scope',
  '$rootScope',
  'Business',
  '$location',
  'GoogleCharts',
  '$cookieStore',
  '$timeout',
  '$interval',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    Business,
    $location,
    GoogleCharts,
    $cookieStore,
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'goals';
    $scope.filterBy = 'date';
    $scope.toggleFilterBy = function(param) {
      $scope.filterBy = param;
      get_business_analytics(
        $rootScope.date.startDate,
        $rootScope.date.endDate
      );
    };

    $scope.size = window.innerWidth;

    get_business_analytics($rootScope.date.startDate, $rootScope.date.endDate);

    $scope.name = 'google_analytics_goals';

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
        '/google_analytics_exports/goals.pdf?' +
        jQuery.param(params);
      $scope.business = Business.google_analytics_goals(params, function(
        response
      ) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            $rootScope.flash = {};
            $rootScope.flash.message = response.errors;
            // $location.path('/dashboard');
            window.location.href = '/b/dashboard'
          } else {
            $scope.ga_sites = response.data.table_data;
            $scope.ga_total_sessions = response.data.total_session;
            $scope.copy_ga_sites = response.data.table_data;
            $scope.total_stats = response.data.chart_data.totalsForAllResults;

            goals_data = GoogleCharts.goals_chart(
              response.data.chart_data.chart_rows
            );
            $scope.goals = function() {
              $timeout(function() {
                $('#completion_chart').highcharts(goals_data[0]);
                $rootScope.resizeChart('completion_chart');
                $('#value_chart').highcharts(goals_data[1]);
                $rootScope.resizeChart('value_chart');
                $('#conversion_chart').highcharts(goals_data[2]);
                $rootScope.resizeChart('conversion_chart');
                $('#abandonment_chart').highcharts(goals_data[3]);
                $rootScope.resizeChart('abandonment_chart');
              }, 10);
            };
            $scope.goals();
            $scope.resize = function() {
              $scope.size = window.innerWidth;
            };
            $interval($scope.resize, 100);
            $scope.$watch('size', function(newValue, oldValue) {
              if (newValue != oldValue) {
                $scope.resizeChart('completion_chart');
                $scope.resizeChart('value_chart');
                $scope.resizeChart('conversion_chart');
                $scope.resizeChart('abandonment_chart');
              }
            });
          }
        }
      });
    }
  }
]);
