clickxApp.controller('GoogleAnalyticsSocialLandingPages', [
  '$scope',
  '$rootScope',
  'GoogleAnalytics',
  '$location',
  'GoogleCharts',
  '$cookieStore',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    GoogleAnalytics,
    $location,
    GoogleCharts,
    $cookieStore,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'landing';

    get_business_analytics($rootScope.date.startDate, $rootScope.date.endDate);

    $scope.name = 'google_analytics_shared_urls';

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
      $cookieStore.put('current_page', window.location.href);
      $scope.business = GoogleAnalytics.social_urls(
        {
          id: $rootScope.current_business,
          start_date: start_date,
          end_date: end_date,
          chart_type: 'default'
        },
        function(response) {
          if (response.status != 200) {
            $rootScope.flash = {};
            $rootScope.flash.message = response.errors;
            // $location.path('/dashboard');
            window.location.href = '/b/dashboard'
          } else {
            var total_sessions = 0;
            var total_pageviews = 0;
            var rows = response.data.urls;
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

            $scope.ga_without_social_refer = _.reject(rows, function(item) {
              'use strict';
              return item.social_refer == 'No';
            });

            $scope.ga_data_toggle_table = $scope.ga_without_social_refer;
            $scope.changeTableData = function(type) {
              'use strict';
              if (type == 'social_session_table') {
                $scope.ga_data_toggle_table = $scope.ga_without_social_refer;
              } else {
                $scope.ga_data_toggle_table = $scope.ga_sites;
              }
            };

            graph_data = GoogleCharts.social_sessions_chart(
              response.data.graph_data
            );
            $('#social_session_chart').highcharts(graph_data[0]);
            $('#all_session_chart').highcharts(graph_data[1]);
          }
        }
      );
    }
  }
]);

/**
 * New Landing Page Controller
 * route: /:business_id/google_analytics/top_pages
 * template_path: reports/google_analytics.html
 */
clickxApp.controller('GoogleAnalyticsSocialNewLandingPages', [
  '$scope',
  '$rootScope',
  'GoogleAnalytics',
  '$timeout',
  '$mdDateRangePicker',
  '$cookieStore',
  function(
    $scope,
    $rootScope,
    GoogleAnalytics,
    $timeout,
    $mdDateRangePicker,
    $cookieStore
  ) {
    'use strict';
    $scope.ga_tab = 'landing_pages';
    $scope.ga_start_date = '30';
    $scope.size = window.innerWidth;
    $scope.filterBy = 'date';
    $scope.toggleFilterBy = function(param) {
      $scope.filterBy = param;
      call_google_landing_analytic($rootScope.date);
    };
    var current_business = $rootScope.current_business;

    $scope.name = 'google_analytics_top_pages';

    call_google_landing_analytic($rootScope.date);

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
        graph_option: $scope.filterBy
      };
      $cookieStore.put('current_page', window.location.href);
      $scope.export_pdf =
        '/businesses/' +
        $rootScope.current_business +
        '/google_analytics_exports/top_pages.pdf?' +
        jQuery.param(params);

      $scope.business = GoogleAnalytics.top_pages(params, function (
        response
      ) {
        if (response.status == 200 && response.data.pages_stats) {
            var total_sessions = 0;
            var total_pageviews = 0;
            var rows = response.data.pages_stats;

            _.each(rows, function(row) {
              row.sessions = parseInt(row.sessions);
              row.screenPageViews = parseInt(row.screenPageViews);
              row.screenPageViewsPerSession = parseFloat(
                row.screenPageViewsPerSession
              ).toFixed(2);
              row.averageSessionDuration = new Date(0, 0, 0).setSeconds(row.averageSessionDuration);

              total_sessions += row.sessions;
              total_pageviews += row.screenPageViews;
            });
            $scope.total_sessions = total_sessions;
            $scope.total_pageviews = total_pageviews;
            $scope.table_data = rows;
            $scope.cp_table_data = rows;

            // $scope.table_data_without_social_refer = _.reject(rows, function(
            //   item
            // ) {
            //   'use strict';
            //   return item.social_refer == 'No';
            // });

            // $scope.filterd_data = $scope.table_data_without_social_refer;
            // var graph_data = GoogleCharts.social_sessions_chart(response.data.pages_stats.graph_data);
            // $scope.top_pages = function () {
            //   $timeout(function () {
            //     $('#social_session_chart').highcharts(graph_data[0]);
            //     $scope.resizeChart('social_session_chart');
            //     $('#all_session_chart').highcharts(graph_data[1]);
            //     $scope.resizeChart('all_session_chart');
            //   }, 10);
            // };
            // $scope.top_pages();
            // $scope.resize = function () {
            //   $scope.size = window.innerWidth;
            // };
            // $interval($scope.resize, 100);
            // $scope.$watch('size', function (newValue, oldValue) {
            //   if (newValue != oldValue) {
            //     $scope.resizeChart('social_session_chart');
            //     $scope.resizeChart('all_session_chart');
            //   }
            // });
        }

          // $scope.changeTableData = function(type) {
          //   if (type == 'all_session_table') {
          //     $scope.filterd_data = $scope.table_data;
          //   } else {
          //     $scope.filterd_data = $scope.table_data_without_social_refer;
          //   }
          // };
        },
        Utility.logError
      );
    }
  }
]);
