clickxApp.controller('AdwordKeyword', [
  '$scope',
  '$rootScope',
  'Business',
  '$location',
  'AdwordsCharts',
  '$cookieStore',
  'BusinessKeywordCheckList',
  '$timeout',
  '$interval',
  '$mdDateRangePicker',
  function(
    $scope,
    $rootScope,
    Business,
    $location,
    AdwordsCharts,
    $cookieStore,
    BusinessKeywordCheckList,
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ad_start_date = '30';
    $scope.ad_tab = 'keyword';
    $scope.keywords_per_page = 10;
    $scope.sort_metric = 'clicks';
    $scope.size = window.innerWidth;
    $scope.name = 'adwords_keyword';
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
     *
     * @param event
     * @param keyword
     *
     * @uses : Add keyword to collection when use click on plus button
     */
    //$scope.addKeyword = function(event,keyword){
    //  Business.add_to_keyword_bank({
    //    id: $routeParams.business_id
    //  },{
    //    keyword: [keyword]
    //  }, function(result){
    //    console.log(result)
    //    if(result.status==201){
    //      toastr.success("Keyword added")
    //    }else{
    //      toastr.warning("This Keyword already added")
    //    }
    //
    //  }, function(error){
    //    console.log(error)
    //  })
    //
    //};

    /**
     * Listen reloadListData - Originated from From directive after add/delete keyword
     */
    $scope.$on('reloadListData', function() {
      BusinessKeywordCheckList.getList(
        $rootScope.current_business,
        $scope.ad_keywords
      ).then(function(result) {
        $scope.copy_ad_keywords = $scope.ad_keywords = result;
      }, Utility.logError);
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
        '/adword_keyword.pdf?' +
        jQuery.param(params);
      $scope.business = Business.adword_keyword(params, function(response) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            toastr.error(response.error, 'Error');
            $location.path('/hub');
          } else {
            $scope.ad_keywords = response.data.total_details;
            $scope.ad_keywords = _.sortBy(
              $scope.ad_keywords,
              'clicks'
            ).reverse();

            if ($scope.ad_keywords.length > 0) {
              $scope.markup_value = $scope.ad_keywords[0].markup_value;
            }
            $scope.copy_ad_keywords = $scope.ad_keywords;

            /* BusinessKeywordCheckList to set a field if it already in keyword bank */
            BusinessKeywordCheckList.getList(
              $rootScope.current_business,
              $scope.ad_keywords
            ).then(function(result) {
              $scope.copy_ad_keywords = $scope.ad_keywords = result;
            }, Utility.logError);

            line_chart_data = AdwordsCharts.performance(
              response.data.this_period,
              response.data.last_period
            );
            $('#clicks_keyword_chart').highcharts(line_chart_data[0]);
            $rootScope.resizeChart('clicks_keyword_chart');
            $scope.keyword = function() {
              $timeout(function() {
                $('#clicks_keyword_chart').highcharts(line_chart_data[0]);
                $rootScope.resizeChart('clicks_keyword_chart');
                $('#impressions_keyword_chart').highcharts(line_chart_data[1]);
                $rootScope.resizeChart('impressions_keyword_chart');
                $('#cost_keyword_chart').highcharts(line_chart_data[2]);
                $rootScope.resizeChart('cost_keyword_chart');
                $('#avg_cost_keyword_chart').highcharts(line_chart_data[3]);
                $rootScope.resizeChart('avg_cost_keyword_chart');
                $('#ctr_keyword_chart').highcharts(line_chart_data[4]);
                $rootScope.resizeChart('ctr_keyword_chart');
                $('#conversions_keyword_chart').highcharts(line_chart_data[5]);
                $rootScope.resizeChart('conversions_keyword_chart');
              }, 10);
            };
            $scope.resize = function() {
              $scope.size = window.innerWidth;
            };
            $interval($scope.resize, 100);
            $scope.$watch('size', function(newValue, oldValue) {
              if (newValue != oldValue) {
                $scope.resizeChart('clicks_keyword_chart');
                $scope.resizeChart('impressions_keyword_chart');
                $rootScope.resizeChart('cost_keyword_chart');
                $scope.resizeChart('avg_cost_keyword_chart');
                $scope.resizeChart('ctr_keyword_chart');
                $rootScope.resizeChart('conversions_keyword_chart');
              }
            });
          }
        }
      });
    }
  }
]);
