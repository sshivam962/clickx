clickxApp.controller('Grader', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  '$routeParams',
  'GraderInfo',
  '$mdDialog',
  'Business',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    $routeParams,
    GraderInfo,
    $mdDialog,
    Business
  ) {
    $scope.current_business_domain =
      $rootScope.current_business_domain || current_business_domain;

    $scope.sidebarSelectionAfterSwitchUser = function() {
      if (
        window.location.hash == '#/grader' &&
        !$('.grader-link').hasClass('open')
      ) {
        $('.grader-link').addClass('open');
      }
    };
    $scope.sidebarSelectionAfterSwitchUser();
    $scope.gradeChart = function() {
      $('#container').highcharts({
        chart: {
          type: 'pie'
        },
        exporting: { enabled: false },
        title: {
          text: ''
        },
        plotOptions: {
          pie: {
            innerSize: '70%',
            showInLegend: false,
            dataLabels: {
              enabled: false
            }
          },
          series: {
            states: {
              hover: {
                enabled: false
              }
            }
          }
        },
        legend: {
          align: 'right',
          layout: 'vertical',
          verticalAlign: 'bottom',
          itemMarginBottom: 25,
          itemStyle: { fontWeight: 'normal' },
          labelFormatter: function() {
            return this.info + ' ' + this.y;
          }
        },
        tooltip: { enabled: false },
        series: [
          {
            data: $scope.overall_grader_chart_data,
            name: '',
            size: 300,
            innerSize: 250,
            pointPadding: 0,
            groupPadding: 0
          }
        ],
        template: 'donut',
        title: {
          align: 'center',
          style: {
            color: '#F8B018',
            fontFamily: 'Arial, Helvetica, sans',
            fontSize: '40px',
            fontWeight: 'bold'
          },
          text: $scope.overall_grader_chart_data[0].name,
          verticalAlign: 'middle',
          y: 5
        }
      });
    };

    $scope.topOrganicKeywordAnalytics = function() {
      $('#top_organic_keyword_chart').highcharts({
        chart: {
          type: 'spline'
        },
        title: {
          text: ''
        },
        subTitle: {
          text: ''
        },
        xAxis: {
          type: 'datetime',
          labels: {
            overflow: 'justify'
          }
        },
        yAxis: {
          title: {
            text: 'SEO Keywords (m/s)'
          },
          minorGridLineWidth: 1,
          gridLineWidth: 1,
          alternateGridColor: null,
          labels: {
            formatter: function() {
              return this.value + 'k';
            }
          }
        },
        tooltip: {
          valueSuffix: ' m/s'
        },
        plotOptions: {
          spline: {
            lineWidth: 2,
            states: {
              hover: {
                lineWidth: 2
              }
            },
            marker: {
              enabled: false
            },
            pointInterval: 3600000, // one hour
            pointStart: Date.UTC(2015, 4, 31, 0, 0, 0)
          }
        },
        series: [
          {
            name: 'Competition',
            data: [0.2, 0.8, 0.8, 0.8, 3, 5, 7],
            color: '#8D6DE3'
          },
          {
            name: 'My Website',
            data: [0, 0, 0.6, 0.9, 0.8, 0.2, 0, 0, 0, 0.1, 0.6],
            color: '#F8B018'
          }
        ],
        navigation: {
          menuItemStyle: {
            fontSize: '10px'
          }
        }
      });
    };

    $scope.topPaidKeywordAnalytics = function() {
      $('#top_paid_keyword_chart').highcharts({
        chart: {
          type: 'spline'
        },
        title: {
          text: ''
        },
        subTitle: {
          text: ''
        },
        xAxis: {
          type: 'datetime',
          labels: {
            overflow: 'justify'
          }
        },
        yAxis: {
          title: {
            text: 'SEO Keywords (m/s)'
          },
          minorGridLineWidth: 1,
          gridLineWidth: 1,
          alternateGridColor: null,
          labels: {
            formatter: function() {
              return this.value + 'k';
            }
          }
        },
        tooltip: {
          valueSuffix: ' m/s'
        },
        plotOptions: {
          spline: {
            lineWidth: 2,
            states: {
              hover: {
                lineWidth: 2
              }
            },
            marker: {
              enabled: false
            },
            pointInterval: 3600000, // one hour
            pointStart: Date.UTC(2015, 4, 31, 0, 0, 0)
          }
        },
        series: [
          {
            name: 'Competition',
            data: [0.2, 0.8, 0.8, 0.8, 3, 5, 7],
            color: '#8D6DE3'
          },
          {
            name: 'My Website',
            data: [0, 0, 0.6, 0.9, 0.8, 0.2, 0, 0, 0, 0.1, 0.6],
            color: '#F8B018'
          }
        ],
        navigation: {
          menuItemStyle: {
            fontSize: '10px'
          }
        }
      });
    };

    $scope.desktop_insights = { score: 0 };
    $scope.mobile_insights = { score: 0 };
    $scope.landing_page_info = { score: 0 };
    $scope.backlinks_info = { score: 0 };
    $scope.total_score_count = 0;

    $scope.websitePerformanceScore = function() {
      $scope.website_performance_avg_score =
        ($scope.desktop_insights.score + $scope.mobile_insights.score) / 2;
      $scope.totalScore();
    };

    $scope.totalScore = function() {
      $scope.total_avg_score = Math.round(
        ($scope.website_performance_avg_score +
          $scope.landing_page_info.score +
          $scope.backlinks_info.score) /
          3
      );

      $scope.overall_grader_chart_data = [
        {
          name: $scope.total_avg_score,
          y: $scope.total_avg_score,
          color: '#F8B018'
        },
        {
          name: 100 - $scope.total_avg_score,
          y: 100 - $scope.total_avg_score,
          color: '#eee'
        }
      ];
      $scope.gradeChart();
    };

    $scope.getDesktopInsights = function() {
      GraderInfo.desktop_insights({}, function(response) {
        $scope.desktop_insights = response.data.insights.desktop;
        $scope.websitePerformanceScore();
        $scope.total_score_count += 1;
      });
    };

    $scope.getMobileInsights = function() {
      GraderInfo.mobile_insights({}, function(response) {
        $scope.mobile_insights = response.data.insights.mobile;
        $scope.websitePerformanceScore();
        $scope.total_score_count += 1;
      });
    };

    $scope.landing_page_info_before_load = true;
    $scope.getLandingPageInfo = function() {
      GraderInfo.landing_page_info({}, function(response) {
        $scope.landing_page_info = response.data.landing_page_info;
        $scope.landing_page_info_before_load = false;
        $scope.totalScore();
        $scope.total_score_count += 1;
      });
    };

    $scope.backlinksInfo = function() {
      GraderInfo.backlinks_info({}, function(response) {
        $scope.backlinks_info = response.data.backlinks_info;
        if ($scope.backlinks_info.backlinks.length == 0) {
          $scope.empty_backlinks = true;
        }
        $scope.totalScore();
        $scope.total_score_count += 1;
      });
    };

    $scope.getOrganicCompetitors = function() {
      GraderInfo.competitors_organic({}, function(response) {
        $scope.organic_competitors = response.data.competitors.organic;
      });
    };

    $scope.getAdwordsCompetitors = function() {
      GraderInfo.competitors_adwords({}, function(response) {
        $scope.adwords_competitors = response.data.competitors.adwords;
      });
    };

    $scope.addDomain = function(domain, event) {
      current_business_id = commonGetCookies('current_business_id');
      if (/([a-z])([a-z0-9]+\.)*[a-z0-9]+\.[a-z.]+/g.test(domain)) {
        domain = domain.replace(/(^\w+:|^)\/\//, '');
        Business.add_domain(
          { id: current_business_id, domain: domain },
          function(response) {
            location.reload();
            toastr.success('Domain added successfully');
          }
        );
      } else {
        toastr.error('Please enter a valid domain');
      }
    };

    $scope.showPrompt = function(ev) {
      $mdDialog.show({
        controller: 'Grader',
        templateUrl: 'set_domain',
        parent: angular.element(document.body),
        targetEvent: ev,
        clickOutsideToClose: false,
        fullscreen: false,
        escapeToClose: false
      });
    };

    if (!$scope.current_business_domain) {
      $scope.showPrompt();
    } else {
      $scope.topOrganicKeywordAnalytics();
      $scope.topPaidKeywordAnalytics();
      $scope.getLandingPageInfo();
      $scope.backlinksInfo();
      $scope.websitePerformanceScore();
      $scope.getDesktopInsights();
      $scope.getMobileInsights();
      $scope.getOrganicCompetitors();
      $scope.getAdwordsCompetitors();
    }
  }
]);
