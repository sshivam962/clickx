clickxApp.controller('GoogleCrawls', [
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
  'CrawlCharts',
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
    CrawlCharts
  ) {
    $rootScope.current_controller = 'home';
    $rootScope.current_business = $routeParams.business_id;
    $rootScope.crawl_errors_counts = {};

    $scope.ga_tab = 'crawl_errors';
    $scope.sort_metric = '';
    $scope.current_page = 1;
    $scope.rows_per_page = 10;
    $scope.visible_pagination_size = 5;
    $scope.error_client = 'web';
    $scope.error_type = 'serverError';
    get_crawl_error_counts();
    get_business_analytics($scope.error_client);
    $scope.tabState = {
      serverError: false,
      soft404: false,
      notFound: false,
      authPermissions: false
    };

    function add_graphs_to_ui() {
      if ($scope.error_client == 'web') {
        $('#web_serverError_errors').highcharts($scope.graph_data.serverError);
        $('#web_soft404_errors').highcharts($scope.graph_data.soft404);
        $('#web_notFound_errors').highcharts($scope.graph_data.notFound);
        $('#web_authPermissions_errors').highcharts(
          $scope.graph_data.authPermissions
        );
      } else if ($scope.error_client == 'mobile') {
        $('#mobile_notFound_errors').highcharts($scope.graph_data.notFound);
        $('#mobile_authPermissions_errors').highcharts(
          $scope.graph_data.authPermissions
        );
      } else {
        $('#smartphoneOnly_serverError_errors').highcharts(
          $scope.graph_data.serverError
        );
        $('#smartphoneOnly_notFound_errors').highcharts(
          $scope.graph_data.notFound
        );
        $('#smartphoneOnly_authPermissions_errors').highcharts(
          $scope.graph_data.authPermissions
        );
      }
    }

    function get_crawl_error_counts() {
      $scope.business = Business.crawl_errors(
        {
          id: $rootScope.current_business,
          client_type: 'count only'
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
              $scope.crawl_errors_counts =
                response.data.latest_counts.countPerTypes;
              $scope.date_wise_counts =
                response.data.date_wise_counts.countPerTypes;
              $scope.graph_data = CrawlCharts.date_wise_errors_graph(
                $scope.date_wise_counts,
                $scope.error_client
              );
              add_graphs_to_ui();
              $scope.set_active_tab();
            }
          }
        }
      );
    }

    function get_business_analytics() {
      $cookieStore.put('current_page', window.location.href);
      $scope.business = Business.crawl_errors(
        {
          id: $rootScope.current_business,
          client_type: $scope.error_client,
          error_type: $scope.error_type
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
              $scope.search_console_errors =
                response.data.list.urlCrawlErrorSample;
              $scope.all_search_console_errors =
                response.data.list.urlCrawlErrorSample;
            }
          }
        }
      );
    }

    $scope.change_error_client = function(error_source) {
      $scope.error_client = error_source;
      $scope.error_type =
        error_source == 'mobile' ? 'authPermissions' : 'serverError';
      get_crawl_error_counts();
      get_business_analytics();
    };

    $scope.change_error_type = function(error_type) {
      // allowed values [authpermissions, manytooneredirect, notfollowed,
      //notfound, other, roboted, servererror, soft404]
      $scope.error_type = error_type;
      $scope.set_active_tab();
      get_business_analytics();
    };

    $scope.set_active_tab = function() {
      $scope.tabState[$scope.error_type] = true;
      setTimeout(function() {
        $('#' + $scope.error_client + '_' + $scope.error_type + '_errors')
          .highcharts()
          .reflow();
      }, 5);
    };

    ($scope.get_error_count = function(client, type) {
      var data = _.where($scope.crawl_errors_counts, {
        category: type,
        platform: client
      })[0];
      if (data) {
        return data.entries[0].count;
      } else {
        return 0;
      }
    }),
      ($scope.check_type = function(err_type) {
        return $scope.error_type == err_type;
      });
  }
]);

clickxApp.controller('GoogleSitemaps', [
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
  'CrawlCharts',
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
    CrawlCharts
  ) {
    $rootScope.current_controller = 'home';
    $rootScope.current_business = $routeParams.business_id;
    $scope.ga_tab = 'sitemaps';
    $scope.sort_metric = '';
    $scope.current_page = 1;
    $scope.rows_per_page = 10;
    $scope.visible_pagination_size = 5;
    get_business_analytics($scope.error_client);

    function get_business_analytics() {
      $cookieStore.put('current_page', window.location.href);
      $scope.business = Business.sitemaps(
        { id: $rootScope.current_business },
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
              $scope.site_url = response.site_url;
              $scope.sitemaps = response.data.sitemap;
              $scope.all_sitemaps = response.data.sitemap;
              $scope.graph_data = CrawlCharts.all_sitemaps($scope.all_sitemaps);
              $('#sitemap_all').highcharts($scope.graph_data);
            }
          }
        }
      );
    }

    $scope.page_view_url = function(url) {
      return url.split($scope.site_url)[1];
    };
  }
]);
