clickxApp.controller('AdwordQueries', [
  '$scope',
  '$rootScope',
  'Business',
  '$location',
  'AdwordsCharts',
  '$cookieStore',
  'BusinessKeywordCheckList',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    Business,
    $location,
    AdwordsCharts,
    $cookieStore,
    BusinessKeywordCheckList,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ad_start_date = '30';
    $scope.ad_tab = 'queries';
    $scope.ads_per_page = 10;
    $scope.sort_metric = 'clicks';
    $scope.name = 'adwords_search_terms';
    end_last_period = moment($rootScope.date.startDate)
      .subtract(1, 'days')
      .format('YYYY-MM-DD');
    period_duration = moment($rootScope.date.endDate).diff(
      moment($rootScope.date.startDate),
      'days'
    );
    start_last_period = moment(end_last_period)
      .subtract(period_duration, 'days')
      .format('YYYY-MM-DD');

    get_adwords(
      $rootScope.date.startDate,
      $rootScope.date.endDate,
      start_last_period,
      end_last_period
    );

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

            end_last_period = moment($rootScope.date.startDate)
              .subtract(1, 'days')
              .format('YYYY-MM-DD');
            period_duration = moment($rootScope.date.endDate).diff(
              moment($rootScope.date.startDate),
              'days'
            );
            start_last_period = moment(end_last_period)
              .subtract(period_duration, 'days')
              .format('YYYY-MM-DD');

            get_adwords(
              $rootScope.date.startDate,
              $rootScope.date.endDate,
              start_last_period,
              end_last_period
            );
          }
        });
    };

    $scope.opts = {
      ranges: {
        Today: [moment(), moment()],
        Yesterday: [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment()],
        'Last Month': [
          moment()
            .subtract(1, 'month')
            .startOf('month'),
          moment()
            .subtract(1, 'month')
            .endOf('month')
        ]
      },
      opens: 'left'
    };

    /**
     * Listen reloadListData - Originated from From directive after add/delete keyword
     */
    $scope.$on('reloadListData', function() {
      BusinessKeywordCheckList.getList(
        $rootScope.current_business,
        $scope.ad_ads
      ).then(
        function(result) {
          $scope.copy_ad_ads = $scope.ad_ads = result;
        },
        function(error) {
          toastr.error(error.toString());
        }
      );
    });

    function get_adwords(
      start_date,
      end_date,
      start_last_period,
      end_last_period
    ) {
      var params = {
        id: $rootScope.current_business,
        start_date: start_date,
        end_date: end_date,
        start_last_period: start_last_period,
        end_last_period: end_last_period
      };
      $cookieStore.put('current_page', window.location.href);
      $scope.export_pdf =
        '/businesses/' +
        $rootScope.current_business +
        '/adword_queries.pdf?' +
        jQuery.param(params);
      $scope.business = Business.adword_queries(params, function(response) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            toastr.error(response.error, 'Error');
            $location.path('/hub');
          } else {
            $scope.ad_ads = response.data.total_details;
            $scope.markup_value = $scope.ad_ads[0].markup_value;
            $scope.copy_ad_ads = $scope.ad_ads;

            BusinessKeywordCheckList.getList(
              $rootScope.current_business,
              $scope.ad_ads
            ).then(
              function(result) {
                $scope.copy_ad_ads = $scope.ad_ads = result;
              },
              function(error) {
                toastr.error(error.toString());
              }
            );
          }
        }
      });
    }
  }
]);
