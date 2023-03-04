clickxApp.controller('GoogleSearchConsole', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  '$location',
  '$routeParams',
  'GoogleCharts',
  '$cookieStore',
  'SearchConsole',
  'BusinessKeywordCheckList',
  '$timeout',
  '$interval',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    $location,
    $routeParams,
    GoogleCharts,
    $cookieStore,
    SearchConsole,
    BusinessKeywordCheckList,
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.size = window.innerWidth;
    $rootScope.current_business = $routeParams.business_id;
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'overview';
    $scope.sort_metric = 'clicks';
    $scope.current_page = 1;
    $scope.rows_per_page = 10;
    $scope.visible_pagination_size = 5;

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
        $routeParams.business_id,
        $scope.search_console_data
      ).then(
        function(result) {
          $scope.all_search_console_data = $scope.search_console_data = result;
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
        end_date: end_date
      };
      $scope.export_pdf =
        '/businesses/' +
        $routeParams.business_id +
        '/google_search_console.pdf?' +
        jQuery.param(params);
      $cookieStore.put('current_page', window.location.href);
      $scope.business = Business.google_search_console(params, function(
        response
      ) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            $rootScope.flash = {};
            $rootScope.flash.message = response.errors;
            toastr.warning(response.errors);
            // $location.path('/dashboard');
            window.location.href = '/b/dashboard'
          } else {
            table_data = SearchConsole.modify_data_for_view(
              response.data.totals
            );
            graph_data = SearchConsole.get_datewise_graph(
              response.data.graph_data
            );
            $scope.search_console_data = table_data.rows;
            $scope.all_search_console_data = table_data.rows;

            BusinessKeywordCheckList.getList(
              $routeParams.business_id,
              $scope.search_console_data
            ).then(
              function(result) {
                $scope.all_search_console_data = $scope.search_console_data = result;
              },
              function(error) {
                console.log(error);
              }
            );

            // $('#position').highcharts(graph_data.position);
            // $scope.resizeChart('position');
            $('#impression').highcharts(graph_data.impressions);
            $scope.resizeChart('impression');
            $scope.searchConsole = function() {
              $timeout(function() {
                // $('#position').highcharts(graph_data.position);
                // $scope.resizeChart('position');
                $('#clicks').highcharts(graph_data.clicks);
                $scope.resizeChart('clicks');
                $('#impression').highcharts(graph_data.impressions);
                $scope.resizeChart('impression');
                // $('#ctr').highcharts(graph_data.ctr);
                // $scope.resizeChart('ctr');
              }, 10);
            };
            $scope.resize = function() {
              $scope.size = window.innerWidth;
            };
            $interval($scope.resize, 100);
            $scope.$watch('size', function(newValue, oldValue) {
              if (newValue != oldValue) {
                // $scope.resizeChart('position');
                $scope.resizeChart('clicks');
                $scope.resizeChart('impression');
                // $scope.resizeChart('ctr');
              }
            });
            _.each($scope.all_search_console_data, function(row) {
              row.keys = row.keys.replace(/['"]+/g, '');
            });
            $scope.csv_file_name =
              $scope.business.site_url +
              '_' +
              moment(new Date()).format('YYYYMMDDTHHmmss') +
              '_SearchAnalytics.csv';
          }
        }
      });
    }

    $scope.download_queries = function() {
      csv_data = $scope.all_search_console_data;
      _.each(csv_data, function(row) {
        row.ctr = row.ctr + '%';
      });
      return csv_data;
    };
    $scope.get_csv_header = function() {
      return ['Queries', 'Clicks', 'Impressions', 'CTR', 'Position'];
    };
  }
]);

clickxApp.controller('GoogleSearchConsolePages', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  '$location',
  '$routeParams',
  'GoogleCharts',
  '$cookieStore',
  'SearchConsole',
  '$timeout',
  '$interval',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    $location,
    $routeParams,
    GoogleCharts,
    $cookieStore,
    SearchConsole,
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.size = window.innerWidth;
    $rootScope.current_business = $routeParams.business_id;
    $scope.ga_start_date = '30';
    $scope.ga_tab = 'pages';
    $scope.sort_metric = 'clicks';
    $scope.current_page = 1;
    $scope.rows_per_page = 10;
    $scope.visible_pagination_size = 5;

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

    $scope.search_console_page_view_url = function(url) {
      return url.split($scope.site_url)[1];
    };

    function get_business_analytics(start_date, end_date) {
      $cookieStore.put('current_page', window.location.href);
      $scope.business = Business.google_search_console_pages(
        {
          id: $rootScope.current_business,
          start_date: start_date,
          end_date: end_date,
          chart_type: 'default'
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
              table_data = SearchConsole.modify_data_for_view(
                response.data.totals
              );
              graph_data = SearchConsole.get_datewise_graph(
                response.data.graph_data
              );
              $scope.site_url = response.site_url;

              $scope.search_console_data = table_data.rows;
              $scope.all_search_console_data = table_data.rows;
              // $('#position').highcharts(graph_data.position);
              // $scope.resizeChart('position');
              $('#impression').highcharts(graph_data.impressions);
              $scope.resizeChart('impression');
              $scope.searchConsole = function() {
                $timeout(function() {
                  // $('#position').highcharts(graph_data.position);
                  // $scope.resizeChart('position');
                  $('#clicks').highcharts(graph_data.clicks);
                  $scope.resizeChart('clicks');
                  $('#impression').highcharts(graph_data.impressions);
                  $scope.resizeChart('impression');
                  // $('#ctr').highcharts(graph_data.ctr);
                  // $scope.resizeChart('ctr');
                }, 10);
              };
              $scope.resize = function() {
                $scope.size = window.innerWidth;
              };
              $interval($scope.resize, 100);
              $scope.$watch('size', function(newValue, oldValue) {
                if (newValue != oldValue) {
                  // $scope.resizeChart('position');
                  $scope.resizeChart('clicks');
                  $scope.resizeChart('impression');
                  // $scope.resizeChart('ctr');
                }
              });
              $scope.csv_file_name =
                $scope.business.site_url +
                '_' +
                moment(new Date()).format('YYYYMMDDTHHmmss') +
                '_SearchAnalytics.csv';
            }
          }
        }
      );
    }
    $scope.download_pages = function() {
      csv_data = $scope.all_search_console_data;
      _.each(csv_data, function(row) {
        row.ctr = row.ctr + '%';
      });
      return csv_data;
    };
    $scope.get_csv_header = function() {
      return ['Pages', 'Clicks', 'Impressions', 'CTR', 'Position'];
    };
  }
]);
