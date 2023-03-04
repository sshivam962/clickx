clickxApp.controller('GoogleAnalyticsAcquisitionCampaigns', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'GoogleAnalytics',
  '$location',
  '$routeParams',
  'GoogleCharts',
  '$cookieStore',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    GoogleAnalytics,
    $location,
    $routeParams,
    GoogleCharts,
    $cookieStore,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'campaigns';

    get_business_analytics($rootScope.date.startDate, $rootScope.date.endDate);

    $scope.name = 'google_analytics_campaigns';

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
        '/google_analytics_exports/campaigns.pdf?' +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.campaigns(
        params,
        function (response) {
          if (response.status == 307) {
            window.location = response.url;
          } else {
            if (response.status != 200) {
              $rootScope.flash = {};
              $rootScope.flash.message = response.errors;
              // $location.path('/dashboard');
              window.location.href = "/b/dashboard";
            } else {
              var total_sessions = 0;
              var total_new_users = 0;
              $scope.ga_campaigns = response.data.campaigns;
              _.each($scope.ga_campaigns, function (row) {
                row.newUsers = parseInt(row.newUsers);
                row.sessions = parseInt(row.sessions);
                row.screenPageViewsPerSession = parseFloat(
                  row.screenPageViewsPerSession
                ).toFixed(2);
                row.averageSessionDuration = new Date(0, 0, 0).setSeconds(row.averageSessionDuration);
                row.bounceRate = parseFloat(row.bounceRate * 100).toFixed(2);
                total_sessions += row.sessions;
                total_new_users += row.newUsers;
              });
              $scope.total_sessions = total_sessions;
              $scope.total_new_users = total_new_users;
              $scope.copy_ga_campaigns = response.data.campaigns;
              // $scope.totals = response.data.totals;
              // campaign_data = GoogleCharts.goals_chart(response.data.chart_data_previous.chart_rows,response.data.chart_data.chart_rows);
              // $('#completion_chart').highcharts(campaign_data[0]);
              // $('#value_chart').highcharts(campaign_data[1]);
              // $('#conversion_chart').highcharts(campaign_data[2]);
              // $('#abandonment_chart').highcharts(campaign_data[3]);
              // $rootScope.resizeChart('completion_chart')
            }
          }
        }
      );
    }
  }
]);
