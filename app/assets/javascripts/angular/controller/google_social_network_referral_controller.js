clickxApp.controller('GoogleAnalyticsSocialNetworkReferral', [
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
    $scope.ga_tab = 'network';
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

    $scope.name = 'google_analytics_social_network_referral';

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
        '/google_analytics_exports/socials.pdf?' +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.social_overview(
        params,
        function(response) {
          if (response.status != 200) {
            $rootScope.flash = {};
            $rootScope.flash.message = response.errors;
            // $location.path('/dashboard');
            window.location.href = '/b/dashboard'
          } else {
            var total_sessions = 0;
            var total_pageviews = 0;
            var rows = _.reject(response.data.socials_data, function(row) {
              return row.site == '(not set)';
            });
            _.each(rows, function(row) {
              row.page_views = parseInt(row.screenPageViews);
              row.sessions = parseInt(row.sessions);
              row.averageSessionDuration = new Date(0, 0, 0).setSeconds(row.averageSessionDuration);
              total_sessions += row.sessions;
              total_pageviews += row.screenPageViews;
            });
            $scope.total_sessions = total_sessions;
            $scope.total_pageviews = total_pageviews;
            $scope.ga_sites = rows;
            $scope.copy_ga_sites = rows;
            graph_data = GoogleCharts.social_sessions_chart(
              response.data.graph_data
            );
            $scope.network = function() {
              $timeout(function() {
                $('#social_session_chart').highcharts(graph_data[0]);
                $scope.resizeChart('social_session_chart');
              }, 10);
            };
            $scope.network();
            $scope.resize = function() {
              $scope.size = window.innerWidth;
            };
            $interval($scope.resize, 100);
            $scope.$watch('size', function(newValue, oldValue) {
              if (newValue != oldValue) {
                $scope.resizeChart('social_session_chart');
              }
            });
          }
        }
      );
    }
  }
]);
