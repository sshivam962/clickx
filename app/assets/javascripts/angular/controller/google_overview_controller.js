clickxApp.controller('GoogleAnalyticsOverview', [
  '$scope',
  '$rootScope',
  'GoogleAnalytics',
  '$timeout',
  '$location',
  'GoogleCharts',
  '$cookieStore',
  '$interval',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    GoogleAnalytics,
    $timeout,
    $location,
    GoogleCharts,
    $cookieStore,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'overview';
    $scope.size = window.innerWidth;
    $scope.filterBy = 'date';
    $scope.name = 'google_analytics_overview';
    $scope.toggleFilterBy = function(param) {
      $scope.filterBy = param;
      analytics_chart_data($rootScope.date.startDate, $rootScope.date.endDate);
    };

    analytics_overview_data($rootScope.date.startDate, $rootScope.date.endDate);
    analytics_chart_data($rootScope.date.startDate, $rootScope.date.endDate);

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
            analytics_overview_data(
              $rootScope.date.startDate,
              $rootScope.date.endDate
            );
          }
        });
    };

    function analytics_overview_data(start_date, end_date) {
      var params = {
        id: $rootScope.current_business,
        start_date: start_date,
        end_date: end_date
      };
      $cookieStore.put('current_page', window.location.href);
      $scope.export_pdf =
        '/businesses/' +
        $rootScope.current_business +
        '/google_analytics_exports/overview.pdf?' +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.overview(params, function (
        response
      ) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            $rootScope.flash = {};
            $rootScope.flash.message = response.errors;
            window.location.href = "/b/dashboard";
          } else {
            $scope.analytics_data = response.data.totals;

            pie_chart_data = GoogleCharts.generic_pie_chart_data(
              response.data.visit_stats
            );
            $('#analytics_pie_chart').highcharts(pie_chart_data);
            $scope.resizeChart('analytics_pie_chart');
          }
        }
      });
    }

    function analytics_chart_data(start_date, end_date) {
      var params = {
        id: $rootScope.current_business,
        start_date: start_date,
        end_date: end_date,
        graph_option: $scope.filterBy,
      };
      $cookieStore.put("current_page", window.location.href);
      $scope.export_pdf =
        "/businesses/" +
        $rootScope.current_business +
        "/google_analytics_exports/overview.pdf?" +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.overview_charts(params, function (response) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            $rootScope.flash = {};
            $rootScope.flash.message = response.errors;
            window.location.href = "/b/dashboard";
          } else {
            charts_data = GoogleCharts.users_chart(
              response.data.charts_data,
              $scope.filterBy
            );
            $scope.overview = function () {
              $timeout(function () {
                $("#visits_chart").highcharts(charts_data[0]);
                $scope.resizeChart("visits_chart");
                $("#visitors_chart").highcharts(charts_data[1]);
                $scope.resizeChart("visitors_chart");
                $("#page_per_visit_chart").highcharts(charts_data[2]);
                $scope.resizeChart("page_per_visit_chart");
                $("#avg_session_chart").highcharts(charts_data[3]);
                $scope.resizeChart("avg_session_chart");
                $("#new_visits_chart").highcharts(charts_data[4]);
                $scope.resizeChart("new_visits_chart");
                $("#bounce_chart").highcharts(charts_data[5]);
                $scope.resizeChart("bounce_chart");
              }, 10);
            };
            $scope.overview();
            $scope.resize = function () {
              $scope.size = window.innerWidth;
            };
            $interval($scope.resize, 100);
            $scope.$watch("size", function (newValue, oldValue) {
              if (newValue != oldValue) {
                $scope.resizeChart("visits_chart");
                $scope.resizeChart("visitors_chart");
                $scope.resizeChart("new_visits_chart");
                $scope.resizeChart("bounce_chart");
                $scope.resizeChart("avg_session_chart");
                $scope.resizeChart("page_per_visit_chart");
              }
            });
          }
        }
      });
    }
  }
]);
