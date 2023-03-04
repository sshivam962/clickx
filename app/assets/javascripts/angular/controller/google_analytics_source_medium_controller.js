clickxApp.controller('GoogleAnalyticsSourceMedium', [
  '$scope',
  '$rootScope',
  'GoogleAnalytics',
  '$location',
  '$cookieStore',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    GoogleAnalytics,
    $location,
    $cookieStore,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'source_medium';

    get_business_analytics($rootScope.date.startDate, $rootScope.date.endDate);

    $scope.name = 'google_analytics_source_medium';

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
      var params = { start_date: start_date, end_date: end_date };
      $cookieStore.put('current_page', window.location.href);
      $scope.export_pdf =
        '/businesses/' +
        $rootScope.current_business +
        '/google_source_medium.pdf?' +
        jQuery.param(params);
      $scope.business = GoogleAnalytics.source_medium(
        {
          id: $rootScope.current_business,
          start_date: start_date,
          end_date: end_date
        },
        function(response) {
          if (response.status == 307) {
            window.location = response.url;
          } else {
            if (response.status != 200) {
              $rootScope.flash = {};
              $rootScope.flash.message = response.errors;
              // $location.path('/dashboard');
              window.location.href = '/b/dashboard'
            } else {
              var total_sessions = 0;
              var total_newusers = 0;
              $scope.ga_source_medium = response.data.source_medium;
              _.each($scope.ga_source_medium, function (row) {
                row.sessions = parseInt(row.sessions);
                row.bounceRate = parseFloat(row.bounceRate * 100).toFixed(2);
                row.averageSessionDuration = new Date(0, 0, 0).setSeconds(
                  row.averageSessionDuration
                );
                total_sessions += row.sessions;
                total_newusers += row.newUsers;
              });
              $scope.total_sessions = total_sessions;
              $scope.total_newusers = total_newusers;
              $scope.copy_ga_source_medium = response.data.source_medium;
              // $scope.totals = response.data.totals;
            }
          }
        }
      );
    }
  }
]);
