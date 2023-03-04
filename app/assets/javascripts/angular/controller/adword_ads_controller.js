clickxApp.controller('AdwordAds', [
  '$scope',
  '$rootScope',
  'Business',
  '$location',
  'AdwordsCharts',
  '$cookieStore',
  '$sce',
  '$mdDialog',
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
    $sce,
    $mdDialog,
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $rootScope.current_controller = 'home';
    $scope.ad_start_date = '30';
    $scope.ad_tab = 'ads';
    $scope.size = window.innerWidth;
    $scope.ads_per_page = 10;
    $scope.sort_metric = 'clicks';
    $scope.tmpl = 'popover-ads.html';
    $scope.tmpl2 = 'popover-ads2.html';
    $scope.name = 'adwords_ads';
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

    $scope.getPopover = function(ad) {
      $scope.dynamicPopover =
        '<div><table><tbody>' +
        '<tr><td><div class="boxed"><ul class= "popup-margin"><li>' +
        '<a class="blue" href="' +
        ad.final_url +
        '" target="_blank">' +
        ad.ad +
        '</a></li><li class="green">' +
        ad.ad_url +
        '</li><li>' +
        ad.ad_desp1 +
        ad.ad_desp2 +
        '</li></ul></div></td></tr></tbody></table></div>';
      return $sce.trustAsHtml($scope.dynamicPopover);
    };

    $scope.getPopover2 = function(ad) {
      $scope.dynamicPopover =
        '<div><table><tbody>' +
        '<tr><td><div class="boxed"><ul class= "popup-margin"><li>' +
        '<a class="blue" href="' +
        ad.final_url +
        '" target="_blank">' +
        ad.heading1 +
        ' ' +
        ad.heading2 +
        '</a></li><li class="green">' +
        ad.final_url +
        '</li><li>' +
        ad.ad_desp +
        '</li></ul></div></td></tr></tbody></table></div>';
      return $sce.trustAsHtml($scope.dynamicPopover);
    };

    $scope.view_image = function(url) {
      $scope.image_url = url;
      $mdDialog.show({
        scope: $scope,
        preserveScope: true,
        templateUrl: 'Image',
        clickOutsideToClose: true
      });
    };

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
        '/adword_ads.pdf?' +
        jQuery.param(params);
      $scope.business = Business.adword_ads(params, function(response) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            toastr.error(response.error, 'Error');
            $location.path('/hub');
          } else {
            $scope.ad_ads = response.data.total_details;
            $scope.ad_ads = _.sortBy($scope.ad_ads, 'clicks').reverse();

            _.map($scope.ad_ads, function(n) {
              if (n.avg_cost != ' --') {
                n.numeric_avg_cost = parseInt(n.avg_cost.split(' ')[0]);
                // n.avg_cost = "$" + (n.avg_cost.split(" ")[0]/1000000).toFixed(2) +  " " +
                //   n.avg_cost.split(" ")[1] + " " +n.avg_cost.split(" ")[2];
                n.avg_cost =
                  '$' + (n.avg_cost.split(' ')[0] / 1000000).toFixed(2);
              } else {
                n.numeric_avg_cost == 0;
              }
            });
            if ($scope.ad_ads.length > 0) {
              $scope.markup_value = $scope.ad_ads[0].markup_value;
            }
            $scope.copy_ad_ads = $scope.ad_ads;

            line_chart_data = AdwordsCharts.performance(
              response.data.this_period,
              response.data.last_period
            );
            $('#clicks_ads_chart').highcharts(line_chart_data[0]);
            $rootScope.resizeChart('clicks_ads_chart');
            $scope.ads = function() {
              $timeout(function() {
                $('#clicks_ads_chart').highcharts(line_chart_data[0]);
                $rootScope.resizeChart('clicks_ads_chart');
                $('#impressions_ads_chart').highcharts(line_chart_data[1]);
                $rootScope.resizeChart('impressions_ads_chart');
                $('#cost_ads_chart').highcharts(line_chart_data[2]);
                $rootScope.resizeChart('cost_ads_chart');
                $('#avg_cost_ads_chart').highcharts(line_chart_data[3]);
                $rootScope.resizeChart('avg_cost_ads_chart');
                $('#ctr_ads_chart').highcharts(line_chart_data[4]);
                $rootScope.resizeChart('ctr_ads_chart');
                $('#conversions_ads_chart').highcharts(line_chart_data[5]);
                $rootScope.resizeChart('conversions_ads_chart');
              }, 10);
            };
            $scope.resize = function() {
              $scope.size = window.innerWidth;
            };
            $interval($scope.resize, 100);
            $scope.$watch('size', function(newValue, oldValue) {
              if (newValue != oldValue) {
                $scope.resizeChart('clicks_ads_chart');
                $scope.resizeChart('impressions_ads_chart');
                $scope.resizeChart('cost_ads_chart');
                $scope.resizeChart('avg_cost_ads_chart');
                $scope.resizeChart('ctr_ads_chart');
                $scope.resizeChart('conversions_ads_chart');
              }
            });
          }
        }
      });
    }
  }
]);
