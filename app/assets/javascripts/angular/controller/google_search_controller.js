clickxApp.controller('GoogleAnalyticsSearches', [
  '$scope',
  '$rootScope',
  'GoogleAnalytics',
  '$location',
  'GoogleCharts',
  '$cookieStore',
  'BusinessKeywordCheckList',
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
    BusinessKeywordCheckList,
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'keywords';
    $scope.size = window.innerWidth;
    $scope.filterBy = 'date';
    $scope.name = 'google_analytics_searches';
    $scope.toggleFilterBy = function(param) {
      $scope.filterBy = param;
      get_business_analytics(
        $rootScope.date.startDate,
        $rootScope.date.endDate
      );
    };

    get_business_analytics($rootScope.date.startDate, $rootScope.date.endDate);

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

    /**
     * Listen reloadListData - Originated from From directive after add/delete keyword
     */
    $scope.$on('reloadListData', function() {
      BusinessKeywordCheckList.getList(
        $rootScope.current_business,
        $scope.ga_search_keywords
      ).then(
        function(result) {
          $scope.copy_ga_search_keywords = $scope.ga_search_keywords = result;
        },
        function(error) {
          toastr.error(error.toString());
          console.log(error);
        }
      );
    });

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
        '/google_analytics_exports/search_analytics.pdf?' +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.searches(params, function(
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
            $scope.ga_search_keywords = response.data.keyword_stats;
            _.each($scope.ga_search_keywords, function(row) {
              row.totalUsers = parseInt(row.totalUsers);
              row.screenPageViewsPerSession = parseFloat(row.screenPageViewsPerSession).toFixed(2);
              row.averageSessionDuration = new Date(0, 0, 0).setSeconds(row.averageSessionDuration);
              row.bounceRate = parseFloat(row.bounceRate * 100).toFixed(2);
            });

            $scope.copy_ga_search_keywords = response.data.keyword_stats;
            // $scope.total_stats = response.data.chart_data.totalsForAllResults;
            // users_data = GoogleCharts.users_chart(
            //   response.data.chart_data.chart_rows
            // );

            BusinessKeywordCheckList.getList(
              $rootScope.current_business,
              $scope.ga_search_keywords
            ).then(
              function(result) {
                $scope.copy_ga_search_keywords = $scope.ga_search_keywords = result;
              },
              function(error) {
                toastr.error(error.toString());
                console.log(error);
              }
            );
            // $scope.searches = function() {
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
            // $scope.searches();
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
