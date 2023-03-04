clickxApp.controller('FbAdsCampaigns', [
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
    $scope.fb_budget = current_fb_budget;
    $scope.ad_tab = 'campaigns';
    $scope.has_ad_account = true;
    $scope.cost = 0.0;
    date = new Date();
    $scope.this_month = date.toLocaleString('en-us', { month: 'long' });
    $scope.month_last_day = new Date(
      date.getFullYear(),
      date.getMonth() + 1,
      0
    ).getDate();
    $scope.today = date.getDate();

    $timeout(function() {
      $rootScope.$watch('date', function(date) {
        get_campaigns(date.startDate, date.endDate);
        get_fbads_graph_data(date.startDate, date.endDate);
      });
    }, 10);

    function get_campaigns(start_date, end_date) {
      var params = {
        id: $scope.current_business,
        start_date: start_date,
        end_date: end_date
      };
      FbAds.campaigns(params, function(result) {
        if (result.status != 200) {
          $scope.error = result.error;
        } else {
          $scope.campaigns = result.data;
          $scope.campaign_details = $scope.copy_campaign_details =
            result.data.insights;
        }
      });
    }

    function get_total_spend_this_month() {
      var params = {
        id: $scope.current_business,
        start_date: $rootScope.current_month_first_date,
        end_date: $rootScope.current_month_last_date
      };
      FbAds.campaigns(params, function(result) {
        if (result.status != 200) {
          $scope.error = result.error;
        } else {
          $scope.cost = result.data.total_spend;
        }
      });
    }
    get_total_spend_this_month();

    $scope.name = 'facebook_ads_campaigns';

    FbAds.fb_account_status(
      {
        id: $scope.current_business
      },
      function(result) {
        $scope.has_ad_account = result.ad_account;
      }
    );

    function get_fbads_graph_data(start_date, end_date) {
      var params = {
        id: $scope.current_business,
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
