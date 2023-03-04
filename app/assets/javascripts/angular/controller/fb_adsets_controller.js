clickxApp.controller('FbAdsets', [
  '$scope',
  'FbAds',
  'FbadsChart',
  '$rootScope',
  '$cookieStore',
  '$interval',
  '$timeout',
  function(
    $scope,
    FbAds,
    FbadsChart,
    $rootScope,
    $cookieStore,
    $interval,
    $timeout
  ) {
    $scope.ad_tab = 'adsets';
    $scope.has_ad_account = true;

    $timeout(function() {
      $rootScope.$watch('date', function(date) {
        get_adset_details(date.startDate, date.endDate);
        get_fbads_graph_data(date.startDate, date.endDate);
      });
    }, 20);

    function get_adset_details(start_date, end_date) {
      var params = {
        id: $rootScope.current_business,
        start_date: start_date,
        end_date: end_date
      };
      FbAds.adsets(params, function(result) {
        if (result.status != 200) {
          $scope.error = result.error;
        } else {
          $scope.adset_details = $scope.copy_adset_details =
            result.data.insights;
        }
      });
      FbAds.campaigns(params, function(result) {
        if (result.status != 200) {
          $scope.error = result.error;
        } else {
          $scope.adsets = result.data;
        }
      });
    }

    $scope.name = 'facebook_ads_adsets';

    FbAds.fb_account_status(
      {
        id: $rootScope.current_business
      },
      function(result) {
        $scope.has_ad_account = result.ad_account;
      }
    );

    function get_fbads_graph_data(start_date, end_date) {
      var params = {
        id: $rootScope.current_business,
        start_date: start_date,
        end_date: end_date
      };
      $cookieStore.put('current_page', window.location.href);
      $scope.graph_data = FbAds.graph_data(params, function(response) {
        var item = FbadsChart.users_chart(response.data);

        $scope.overview = function() {
          $timeout(function() {
            $('#fbads_clicks_line_chart').highcharts(item[0]);
            $scope.resizeChart('fbads_clicks_line_chart');
            $('#fbads_impressions_line_chart').highcharts(item[1]);
            $scope.resizeChart('fbads_impressions_line_chart');
            $('#fbads_cpc_line_chart').highcharts(item[2]);
            $scope.resizeChart('fbads_cpc_line_chart');
          }, 10);
        };
        $scope.overview();

        $scope.resize = function() {
          $scope.size = window.innerWidth;
        };
        $interval($scope.resize, 100);
        $scope.$watch('size', function(newValue, oldValue) {
          if (newValue != oldValue) {
            $scope.resizeChart('fbads_clicks_line_chart');
            $scope.resizeChart('fbads_impressions_line_chart');
            $scope.resizeChart('fbads_cpc_line_chart');
          }
        });
      });
    }
  }
]);
