clickxApp.controller('SeoRankHistory', [
  '$scope',
  'Business',
  '$rootScope',
  '$routeParams',
  '$http',
  '$window',
  'SeoKeywordsChart',
  '$interval',
  function(
    $scope,
    Business,
    $rootScope,
    $routeParams,
    $http,
    $window,
    SeoKeywordsChart,
    $interval
  ) {
    $scope.business_id = $routeParams.business_id;
    $scope.keyword = $routeParams.keyword;
    $scope.itemsByPage = 30;
    $scope.isLoading = true;
    $scope.sort_order = {
      rank_date: false,
      google_rank: false
    };
    $scope.timespan = '30_days';

    $scope.goBack = function () {
      $window.location.href = '/#/rankings';
    };
    $scope.sort_by = 'rank_date';
    $scope.sortBy = function(sort_parameter) {
      $scope.sort_by = sort_parameter;
      $scope.sort_order[$scope.sort_by] = !$scope.sort_order[$scope.sort_by];
      $scope.stCtrl.pipe($scope.stCtrl.tableState());
    };

    $scope.params = {
      keyword_id: $scope.keyword,
      sort_by: $scope.sort_by,
      sort_order: $scope.sort_order[$scope.sort_by],
      timespan: $scope.timespan
    };

    $scope.getData = function (params) {
      $scope.csv_all_url = '/businesses/' + $scope.business_id + '/keyword_rank_history.csv?' + jQuery.param(params);
      $http({
        method: 'GET',
        url:
          '/businesses/' + $scope.business_id + '/keyword_rank_history.json?',
        params: params
      }).then(function Success(response) {
        $scope.isLoading = false;
        if (response.data.status == 200) {
          $scope.competitors_rank = response.data.competitors_rank;
          $scope.history = response.data.data;
          $scope.history_safe_copy = $scope.history;
          $scope.dates = _.map(_.pluck($scope.history, 'rank_date'), function (date) {
            return moment(date).format('MMM. Do');
          });
          $scope.google_rank = _.pluck($scope.history, 'google_rank');
          $scope.loadCharts('google_rank_history', $scope.dates, $scope.google_rank, 'Google Rank History');
          $scope.keyword_name = response.data.keyword_name;
        }
      })
      .catch(function Error(error) {
        $scope.isLoading = false;
        $scope.competitors_rank = [];
        $scope.history = [];
      })
        .then(function Success(response) {
          $scope.isLoading = false;
          if (response.data.status == 200) {
            $scope.competitors_rank = response.data.competitors_rank;
            $scope.history = response.data.data;
            $scope.history_safe_copy = $scope.history;
            $scope.dates = _.map(_.pluck($scope.history, 'rank_date'), function(
              date
            ) {
              return moment(date).format('MMM. Do');
            });
            $scope.google_rank = _.pluck($scope.history, 'google_rank');
            $scope.loadCharts(
              'google_rank_history',
              $scope.dates,
              $scope.google_rank,
              'Google Rank History'
            );
            $scope.keyword_name = response.data.keyword_name;
          }
        })
        .catch(function Error(error) {
          $scope.isLoading = false;
          $scope.competitors_rank = [];
          $scope.history = [];
        });
    };

    $scope.changeTimeSpan = function (timespan) {
      $scope.timespan = timespan;
      $scope.params = {
        keyword_id: $scope.keyword,
        sort_by: $scope.sort_by,
        sort_order: $scope.sort_order[$scope.sort_by],
        timespan: $scope.timespan
      };
      $scope.getData($scope.params);
    };

    $scope.readableDate = function (date) {
      return moment(date).format('dddd, MMMM Do YYYY');
    };

    $scope.loadCharts = function(id, dates, rank, title) {
      chart_data = SeoKeywordsChart.keywordHistory(dates, rank, title);
      $('#' + id).highcharts(chart_data);
      $scope.resizeChart(id);
    };
    $scope.perPage = function(limit) {
      $scope.itemsByPage = limit;
      $scope.stCtrl.pipe($scope.stCtrl.tableState());
    };
    $scope.resize = function() {
      $scope.size = $window.innerWidth;
    };
    $interval($scope.resize, 100);
    $scope.$watch('size', function(newValue, oldValue) {
      if (newValue != oldValue) {
        $scope.resizeChart('google_rank_history');
      }
    });

    $scope.getData($scope.params);
  }
]);
