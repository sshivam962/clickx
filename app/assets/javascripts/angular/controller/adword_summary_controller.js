clickxApp.controller('AdwordSummary', [
  '$scope',
  '$rootScope',
  'Business',
  '$location',
  'AdwordsCharts',
  '$cookieStore',
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
    $timeout,
    $interval,
    $mdDateRangePicker
  ) {
    $scope.ppc_budget = current_ppc_budget;
    $scope.cost = 0.0;
    $scope.name = 'adwords_summary';
    date = new Date();
    $scope.today = date.getDate();
    $scope.size = window.innerWidth;
    $scope.month_last_day = new Date(
      date.getFullYear(),
      date.getMonth() + 1,
      0
    ).getDate();

    months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    $scope.this_month = months[date.getMonth()];

    $rootScope.current_controller = 'home';
    $scope.ad_start_date = '30';
    $scope.ad_tab = 'summary';
    end_last_period = moment($rootScope.date.startDate)
      .subtract(1, 'days')
      .format('YYYY-MM-DD');
    period_duration = moment($rootScope.date.endDate).diff(
      moment($rootScope.date.startDate),
      'days'
    );
    start_last_period = moment(end_last_period)
      .subtract(30, 'days')
      .format('YYYY-MM-DD');

    get_adwords(
      $rootScope.date.startDate,
      $rootScope.date.endDate,
      start_last_period,
      end_last_period
    );
    if ($scope.ppc_budget > 0.0) {
      adword_budget_pacing(
        $rootScope.current_month_first_date,
        $rootScope.current_month_last_date,
        start_last_period,
        end_last_period
      );
    }

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
        'Last 30 Days': [
          moment().subtract(30, 'days'),
          moment().subtract(1, 'days')
        ],
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
        '/adword_summary.pdf?' +
        jQuery.param(params);
      $scope.business = Business.adword_summary(params, function(response) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status != 200) {
            toastr.error(response.error, 'Error');
            $location.path('/hub');
          } else {
            $scope.adwords_data = response.data.total_details;

            line_chart_data = AdwordsCharts.performance(
              response.data.this_period,
              response.data.last_period
            );
            $('#clicks_line_chart').highcharts(line_chart_data[0]);
            $rootScope.resizeChart('clicks_line_chart');
            $scope.summary = function() {
              $timeout(function() {
                $('#clicks_line_chart').highcharts(line_chart_data[0]);
                $rootScope.resizeChart('clicks_line_chart');
                $('#impressions_line_chart').highcharts(line_chart_data[1]);
                $rootScope.resizeChart('impressions_line_chart');
                $('#conversions_line_chart').highcharts(line_chart_data[5]);
                $rootScope.resizeChart('conversions_line_chart');
              }, 10);
            };
            $scope.resize = function() {
              $scope.size = window.innerWidth;
            };
            $interval($scope.resize, 100);
            $scope.$watch('size', function(newValue, oldValue) {
              if (newValue != oldValue) {
                $rootScope.resizeChart('clicks_line_chart');
                $scope.resizeChart('impressions_line_chart');
                $scope.resizeChart('conversions_line_chart');
              }
            });
          }
        }
      });
    }

    function adword_budget_pacing(
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
      $scope.business = Business.adword_summary(params, function(response) {
        if (response.status == 307) {
          window.location = response.url;
        } else {
          if (response.status == 200) {
            $scope.data = response.data.total_details;
            $scope.cost = $scope.data['cost'] / 1000000;
          }
        }
      });
    }
  }
]);
