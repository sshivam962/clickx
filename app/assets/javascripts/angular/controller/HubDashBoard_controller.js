clickxApp.controller('HubDashBoard', [
  '$scope',
  '$localStorage',
  '$rootScope',
  '$http',
  '$resource',
  '$window',
  '$location',
  '$mdDialog',
  'Users',
  '$routeParams',
  '$route',
  '$cookieStore',
  'HubCharts',
  'funnelConsole',
  'funnelCharts',
  'MarketingCharts',
  'progressBarManager',
  'SeoKeywordsChart',
  'Competition',
  'GoogleAnalyticsService',
  'ReviewCharts',
  'Business',
  'User',
  'Businesses',
  '$timeout',
  '$interval',
  '$mdDateRangePicker',
  '$filter',
  function(
    $scope,
    $localStorage,
    $rootScope,
    $http,
    $resource,
    $window,
    $location,
    $mdDialog,
    Users,
    $routeParams,
    $route,
    $cookieStore,
    HubCharts,
    funnelConsole,
    funnelCharts,
    MarketingCharts,
    progressBarManager,
    SeoKeywordsChart,
    Competition,
    GoogleAnalyticsService,
    ReviewCharts,
    Business,
    User,
    Businesses,
    $timeout,
    $interval,
    $mdDateRangePicker,
    $filter
  ) {
    $scope.marketingPerformanceStatus = true;
    $rootScope.marketing_service_enabled = 'true';
    $scope.marketing_performance_loaded = false;

    $scope.business = this_business;

    $scope.timeselect = 'custom_date_range';
    $scope.compared = 'previous_period';
    $rootScope.id = $routeParams.business_id;
    $rootScope.current_business = current_business;
    $rootScope.current_controller = 'dashboard';
    $scope.isBar = true;
    $scope.ProgressVal = $rootScope.ProgressVal;
    $scope.bar = progressBarManager();
    $scope.deviceWidth = window.innerWidth;
    $scope.size = window.innerWidth;
    var params = {
      id: $routeParams.business_id,
      start_date: $rootScope.date.startDate,
      end_date: $rootScope.date.endDate
    };
    var init_all_graphs = function() {
      $timeout(function() {
        $scope.init_marketing_performance_page();
        if ($scope.business.google_analytics_id) $scope.init_google_analytics();
        $scope.init_google_search_console_page();
        if (current_ppc_service) $scope.init_adwords_page();
        if ($scope.business.backlink_service) $scope.init_backlinks_page();
        if ($scope.business.competitors_service) $scope.init_competition_page();
        if (current_calls_enabled) $scope.init_call_analytics_page();
        $scope.init_review_page();
        if ($scope.business.google_analytics_id) $scope.init_visitors_page();
        if (current_seo_enabled) $scope.init_keywords_page();
      });
    };

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
            params.start_date = moment(result.dateStart).format('YYYY-MM-DD');
            params.end_date = moment(result.dateEnd).format('YYYY-MM-DD');
            if (
              result.selectedTemplate &&
              result.selectedTemplate != 'Last 30 Days'
            )
              $scope.timeselect = $filter('snakeCase')(
                result.selectedTemplateName
              );
            else $scope.timeselect = 'custom_date_range';
            $rootScope.selectedRange = result;
            $rootScope.date = {
              startDate: params.start_date,
              endDate: params.end_date
            };
            init_all_graphs();
          }
        });
    };
    $scope.setGoals = function(ev, title) {
      $rootScope.goals_title = title;
      $mdDialog
        .show({
          controller: 'SetGoalsFunnelAnalytics',
          templateUrl: 'set_goals',
          parent: angular.element(document.body),
          targetEvent: ev,
          clickOutsideToClose: false,
          fullscreen: false
        })
        .finally($scope.init_marketing_performance_page);
      //@see https://material.angularjs.org/latest/api/service/$mdDialog
      //.then($scope.init_marketing_performance_page, $scope.init_marketing_performance_page);
    };
    var resizeAllCharts = function() {
      //marketing-performance
      $scope.resizeChart('visits_line_chart');
      $scope.resizeChart('contact_line_chart');
      $scope.resizeChart('customer_line_chart');
      ///keywords
      $scope.resizeChart('all-time-keywords-google');
      ///google-analytics
      $scope.resizeChart('visitors_chart');
      $scope.resizeChart('new_visits_chart');
      $scope.resizeChart('bounce_chart');
      $scope.resizeChart('avg_session_chart');
      $scope.resizeChart('page_per_visit_chart');
      ///SearchConsole
      $scope.resizeChart('position_chart');
      $scope.resizeChart('clicks_chart');
      $scope.resizeChart('impression_chart');
      $scope.resizeChart('ctr_chart');
      ///adwords
      $scope.resizeChart('clicks_line_chart');
      $scope.resizeChart('impressions_line_chart');
      $scope.resizeChart('conversions_line_chart');
      ////backlinks
      $scope.resizeChart('donut-summary');
      $scope.resizeChart('donut-citation');
      ///call_analytics
      $scope.resizeChart('calls_by_status_chart');
      $scope.resizeChart('unique_calls_chart');
      ///ReviewCharts
      $scope.resizeChart('chart_div');
      ///visitors
      $scope.resizeChart('analytics_pie_chart');
    };
    $scope.hubPageOrder = [
      {
        title: 'Marketing_Performance',
        classWidth: 'fullWidth',
        status: 'marketingPerformanceStatus',
        pos: 0,
        active: 'marketing_service_enabled'
      },
      {
        title: 'best_ads',
        classWidth: 'fullWidth',
        status: 'bestAdsStatus',
        pos: 1,
        active: 'dashlets_enabled'
      },
      {
        title: 'contacts_per_day',
        classWidth: 'fullWidth',
        status: 'contactsPerDayStatus',
        pos: 2,
        active: 'dashlets_enabled'
      },
      {
        title: 'top_10_keywords',
        classWidth: 'halfWidth',
        status: 'topKeywordsStatus',
        pos: 3,
        active: 'dashlets_enabled'
      },
      {
        title: 'contacts_by_source',
        classWidth: 'halfWidth',
        status: 'bySourceStatus',
        pos: 4,
        active: 'dashlets_enabled'
      },
      {
        title: 'recent_contacts',
        classWidth: 'halfWidth',
        status: 'contactsOverviewStatus',
        pos: 5,
        active: 'dashlets_enabled'
      },
      {
        title: 'google_analytics',
        classWidth: 'halfWidth',
        status: 'googleAnalyticsStatus',
        pos: 6,
        active: 'google_analytics_enabled'
      },
      {
        title: 'google_search_console',
        classWidth: 'halfWidth',
        status: 'googleSearchConsoleStatus',
        pos: 7,
        active: 'search_console_enabled'
      },
      {
        title: 'ads',
        classWidth: 'halfWidth',
        status: 'adwordsStatus',
        pos: 8,
        active: 'adword_enabled'
      },
      {
        title: 'keywords',
        classWidth: 'halfWidth',
        status: 'keywordsStatus',
        pos: 9,
        active: 'seo_reports_enabled'
      },
      {
        title: 'competitors',
        classWidth: 'halfWidth',
        status: 'competitorsStatus',
        pos: 12,
        active: 'competitors_service_enabled'
      },
      {
        title: 'backlinks',
        classWidth: 'halfWidth',
        status: 'backlinksStatus',
        pos: 13,
        active: 'backlink_service_enabled'
      },
      {
        title: 'call_analytics',
        classWidth: 'halfWidth',
        status: 'callAnalyticsStatus',
        pos: 14,
        active: 'call_analytics_enabled'
      },
      {
        title: 'reviews',
        classWidth: 'halfWidth',
        status: 'reviewStatus',
        pos: 15,
        active: 'reviews_enabled'
      },
      {
        title: 'visitors',
        classWidth: 'halfWidth',
        status: 'visitorsStatus',
        pos: 17,
        active: 'google_analytics_enabled'
      }
    ];

    var initializeChart = function(chart_ids, data) {
      _.each(chart_ids, function(chart_id, index) {
        $(chart_id).highcharts(data[index]);
        $(chart_id).highcharts();
      });
    };

    /// sortable
    $scope.sortableOptions = {
      stop: function(e, ui) {
        for (var index in $scope.hubPageOrder) {
          $scope.hubPageOrder[index].pos = index;
        }
        logModels();
      }
    };

    function logModels() {
      var logEntry = [];
      $scope.hubPageOrder.map(function(element) {
        logEntry.push({
          title: element.title,
          classWidth: element.classWidth,
          status: element.status,
          pos: element.pos,
          active: element.active
        });
        return logEntry;
      });
    }
    ///eof sortable
    $scope.$storage = $localStorage.$default({
      pageOrder: $scope.hubPageOrder
    });

    if ($scope.$storage.pageOrder.length != $scope.hubPageOrder.length) {
      $localStorage.$reset({
        pageOrder: $scope.hubPageOrder
      });
    }

    $scope.hubPageOrderlog = $scope.$storage.pageOrder;
    ///eof localStorage
    $scope.getNewUrl = function(val) {
      return 'themeX/home/dashboard/' + val + '.html';
    };

    /// marketing_performance
    $scope.init_marketing_performance_page = function() {
      var chart_ids = [
        '#visits_line_chart',
        '#contact_line_chart',
        '#customer_line_chart'
      ];
      Business.marketing_performance_goal(
        { business_id: $routeParams.business_id },
        function(response) {
          $scope.visits = response.visits_per_month;
          $scope.contacts = response.contacts_per_month;
          $scope.customers = response.customers_per_month;
        },
        function(error) {
          $scope.visits = $scope.contacts = $scope.customers = 0;
        }
      );
      params['date_range'] = $scope.timeselect;
      params['compared_to'] = $scope.compared;
      Business.marketing_performance(params, function(response) {
        $scope.marketingPerformanceStatus = response.status;
        if (response.status == 200) {
          $scope.marketingPerformanceStatus = true;
          $scope.count = response.data.this_period.total_counts;
          $scope.visit_percent =
            parseFloat(response.data.visit_to_contact_percentage || 0).toFixed(
              2
            ) + '%';
          $scope.contact_pecent =
            parseFloat(
              response.data.contact_to_customers_percentage || 0
            ).toFixed(2) + '%';
          $timeout(function() {
            marketing_performance_chart_data = MarketingCharts.performance(
              response.data.this_period,
              response.data.last_period,
              $scope.visits,
              $scope.contacts,
              $scope.customers
            );
            initializeChart(chart_ids, marketing_performance_chart_data);
            $scope.marketing_performance_loaded = true;
          });
        } else {
          $scope.marketingPerformanceStatus = false;
        }
      });
    };
    // /// eof marketing_performance

    // Intelligence Methods

    $scope.contacts_per_day = function(data) {
      if (_.isEmpty(data)) $scope.contactsPerDayStatus = false;
      else {
        $scope.contactsPerDayStatus = true;
        $scope.contactsPerDay = HubCharts.contacts_per_day(data);
      }
    };

    $scope.new_contacts_by_source = function(data) {
      var processed_data = _.map(data, function(value, key) {
        return { name: key, y: value };
      });
      processed_data = _.sortBy(processed_data, function(value) {
        return -value.y;
      });
      if (processed_data.length) {
        $scope.bySourceStatus = true;
        $scope.contactsBySource = HubCharts.contacts_by_source(processed_data);
      } else $scope.bySourceStatus = false;
    };

    $scope.best_performing_ads = function(data) {
      if (data && data.length) {
        $scope.bestAdsStatus = true;
        $scope.dashlets['best_performing_ads'] = data;
      } else $scope.bestAdsStatus = false;
    };

    $scope.top_keywords = function(data) {
      if (data && data.length) {
        $scope.topKeywordsStatus = true;
        $scope.dashlets['top_10_keywords'] = data;
      } else $scope.topKeywordsStatus = false;
    };

    $scope.contacts_overview = function(data) {
      if (
        data &&
        angular.isDefined(data.contacts_in_24_hours) &&
        data.contacts_in_24_hours.length
      ) {
        $scope.contactsOverviewStatus = true;
        $scope.dashlets['contacts_overview'] = data;
      } else $scope.contactsOverviewStatus = false;
    };

    $scope.init_intelligence_dashlets = function() {
      $scope.init_marketing_performance_page();
      Business.all_intelligence(
        params,
        function(response) {
          if (response) {
            $scope.dashletStatus = true;
            $scope.dashlets = response;
            $scope.contacts_overview(response.contacts_overview);
            $scope.top_keywords(response.top_10_keywords);
            $scope.best_performing_ads(response.best_performing_ads);
            $scope.new_contacts_by_source(response.new_contacts_by_source);
            $scope.contacts_per_day(response.contacts_per_day);
            if (current_seo_enabled && response.datewise_rankings)
              $scope.setKeywordGraph(
                angular.fromJson(response.datewise_rankings)
              );
            if (
              $scope.business.backlink_service &&
              response.last_30_days_backlinks
            )
              $scope.backlinksData(response.last_30_days_backlinks);
            if (
              $scope.business.competitors_service &&
              response.last_30_days_business_competitiors
            )
              $scope.competitionsData(
                response.last_30_days_business_competitiors
              );
            if (current_calls_enabled && response.last_30_days_call_analytics)
              $scope.callAnalyticsData(response.last_30_days_call_analytics);
            if (
              $rootScope.local_profile_enabled != 'false' &&
              response.reviews_stars
            )
              $scope.reviewsData(response.reviews_stars);
            $scope.init_google_search_console_page();
            if (
              $scope.business.google_analytics_id &&
              response.last_30_days_google_analytics &&
              !_.isEmpty(response.last_30_days_google_analytics.users_data)
            )
              $scope.init_google_analytics()
            if (
              current_ppc_service &&
              response.last_30_days_adwords_ppc_summary
            )
              $scope.init_adwords_page()
            if (
              $scope.business.google_analytics_id &&
              response.last_30_days_google_analytics &&
              response.last_30_days_google_analytics.totals
            )
              $scope.visitorsData(response.last_30_days_google_analytics);
          }
        },
        function(error) {
          $scope.dashletStatus = false;
        }
      );
    };

    $scope.refresh_intelligence = function(method) {
      var params = {
        method: method,
        id: $routeParams.business_id
      };
      Business.dashlet_intelligence(
        params,
        function(response) {
          $scope[method](response.data);
        },
        function(error) {
          $scope.dashletStatus = false;
        }
      );
    };

    // EOF Intelligence Methods

    ////google_analytics

    $scope.googleAnalyticsData = function(response) {
      if (_.isEmpty(response.users_data)) return;
      $scope.googleAnalyticsStatus = true;
      $scope.analytics_data = response.totals;
      $scope.users_datas = HubCharts.google_users_chart(
        response.users_data_previous,
        response.users_data
      );
    };

    $scope.init_google_analytics = function() {
      Business.google_analytics_overview(params, function(response) {
        if (response.status == 200) {
          $scope.googleAnalyticsData(response.data);
        } else {
          $scope.googleAnalyticsStatus = false;
        }
      });
    };

    $scope.goTo = function(path) {
      $window.location.href = '#/' + path;
    };
    // eof google_analytics
    ///keywords
    $scope.init_keywords_page = function() {
      $scope.keywords = [];
      $scope.loadingTable = false;
      $scope.timespan = 'all_time';
      $scope.filterData = {
        id: $rootScope.id,
        date_string: $scope.timespan
      };
      $rootScope.keywordResult.$promise.then(function(result) {
        $scope.keywordsStatus = result.status == 200 ? true : false;
      });
      var keywordChart = Business.get_datewise_rankings($scope.filterData);
      keywordChart.$promise.then(function(result) {
        $scope.setKeywordGraph(result);
      });
    };

    $scope.setKeywordGraph = function(result) {
      $scope.keywordRowData = result.row;
      var processedData = SeoKeywordsChart.processKeyWordData(
        result,
        'all_time'
      );
      $scope.keyWordChartOptions = SeoKeywordsChart.getKeyWordDataChart(
        processedData.allKeywordsDate,
        processedData.searchEngineData,
        false
      )[0];
      if (result.row.length) $scope.keywordsStatus = true;
    };
    /// eof keywords
    ///// google_search_console
    $scope.init_google_search_console_page = function() {
      Business.google_search_console(params, function(response) {
        if (response.status == 200) {
          $scope.searchConsoleData(response.data);
        } else {
          $scope.googleSearchConsoleStatus = false;
        }
      });
    };

    $scope.searchConsoleData = function(response) {
      if (!_.isEmpty(response)) {
        $scope.googleSearchConsoleStatus = true;
        var graph_data = response.graph_data;
        if (graph_data != null) {
          var click = _.pluck(graph_data.rows, 'clicks');
          var ctr = _.pluck(graph_data.rows, 'ctr');
          var impressions = _.pluck(graph_data.rows, 'impressions');
          var position = _.pluck(graph_data.rows, 'position');
          $scope.clicks = _.reduce(
            click,
            function(memo, num) {
              return memo + num;
            },
            0
          );
          $scope.ctr = _.reduce(
            ctr,
            function(memo, num) {
              return memo + num;
            },
            0
          ).toFixed(2);
          $scope.impressions = _.reduce(
            impressions,
            function(memo, num) {
              return memo + num;
            },
            0
          );
          $scope.position = parseInt(
            _.reduce(
              position,
              function(memo, num) {
                return memo + num;
              },
              0
            ).toFixed(2)
          );
          $scope.console_data = funnelConsole.get_console_graphs(
            response.graph_data,
            response.graph_data_previous
          );
        }
      }
    };
    /// eof google_search_console
    //// adwords
    $scope.init_adwords_page = function() {
      Business.adword_summary(params, function(response) {
        if (response.status == 200) {
          $scope.adwordsPPCSummaryData(response.data);
        } else {
          $scope.adwordsStatus = false;
        }
      });
    };

    $scope.adwordsPPCSummaryData = function(response) {
      if (_.isEmpty(response.this_period)) return;
      $scope.adwordsStatus = true;
      $scope.adwords_data = response.total_details;
      $scope.Impressions = parseInt($scope.adwords_data[3]);
      $scope.Interactions = parseInt($scope.adwords_data[2]);
      $scope.Conversion = parseInt($scope.adwords_data[7]);
      $scope.adwords_chart_data = funnelCharts.adwords_performance(
        response.this_period,
        response.last_period
      );
    };
    /// eof adwords

    //// backlinks
    $scope.init_backlinks_page = function() {
      Business.backlinks_summary({ id: params.id }, function(response) {
        if (response.status == 200) {
          $scope.backlinksData(response.data);
        } else {
          $scope.backlinksStatus = false;
        }
      });
    };

    $scope.backlinksData = function(response) {
      $scope.backlinksStatus = true;
      $scope.backlinksChart = HubCharts.backlinksChart(response);
      $scope.ExtBackLinks = response.ExtBackLinks;
      $scope.RefDomains = response.RefDomains;
    };
    /// eof backlinks
    ///competition
    $scope.init_competition_page = function() {
      $scope.competitions = [];
      $scope.all_competition_data = $scope.competitions;
      $scope.seo_tab = 'competition';

      Competition.competition(
        { business_id: $rootScope.id },
        $scope.competitionsData
      );
      $scope.selectedCompData = null;
    };
    $scope.competition_refresh = function() {
      $scope.init_competition_page();
    };

    $scope.competitionsData = function(response) {
      $scope.competitions = response;
      $scope.competitorsStatus = true;
      $scope.all_competition_data = $scope.competitions;

      /**
       * @description Open competition delete modal
       * @param compData
       * @todo Can be use old competitionDeleteModal.html snippet used in competition page
       */
      $scope.openCompetitionDelete = function(compData) {
        console.log('CLICKX PROGRESS');
        $mdDialog
          .show({
            controller: 'CompetitionDeleteCtrl',
            templateUrl: 'competitionDeleteModalHub.html',
            locals: {
              compData: compData
            }
          })
          .then(
            function(info) {
              toastr.success('Competition "' + info.name + '" deleted');
              // $scope.selectedCompData = null;
              $route.reload();
            },
            function() {}
          );
      };

      $scope.openAddCompetition = function() {
        $mdDialog
          .show({
            controller: 'AddCompetition',
            templateUrl: 'themeX/competitions/_add_competition.html'
          })
          .then(function() {
            Competition.competition({ business_id: $rootScope.id }, function(
              response
            ) {
              $scope.competitions = response;
              $scope.all_competition_data = $scope.competitions;
            });
          });
      };

      $scope.go_back = function() {
        $window.history.back();
      };
    };
    //// eof competition

    /// call analytics
    $scope.init_call_analytics_page = function() {
      Business.get_calls({ id: params.id }, function(data) {
        if (data.status == 200) {
          $scope.callAnalyticsData(data.calls);
        } else {
          $scope.callAnalyticsStatus = false;
        }
      });
    };

    $scope.callAnalyticsData = function(data) {
      $scope.callAnalyticsStatus = true;
      $scope.calls = data;
      $scope.all_calls = data;
      _.each($scope.calls, function(obj) {
        obj.only_date = obj.call_s.split(' ')[0];
      });

      var data_in_range = _.filter($scope.all_calls, function(obj) {
        return (
          obj.only_date >= params.start_date && obj.only_date <= params.end_date
        );
      });
      call_status_data = _.countBy(data_in_range, function(obj) {
        return obj.call_status;
      });
      $scope.pie_chart_data = HubCharts.call_status_pie_chart_data(
        call_status_data
      );
      unique_calls_data = _.countBy(data_in_range, function(obj) {
        return obj.caller_number;
      });
      calls_count = _.countBy(unique_calls_data, function(val, key) {
        return val;
      });
      greater_than_five = 0;
      _.each(calls_count, function(val, key) {
        if (key > 5) {
          greater_than_five = greater_than_five + val;
        }
      });
      $scope.unique_calls_bar_chart_data = HubCharts.unique_calls_bar_chart_data(
        calls_count,
        greater_than_five
      );
      // $timeout(function() {
      //   initializeChart(['#calls_by_status_chart', '#unique_calls_chart'], [pie_chart_data, unique_calls_bar_chart_data]);
      // }, 10);
    };
    /// eof call_analytics

    $scope.socialRetargetingData = function(response) {
      if (
        response.campaign_report.length > 0 &&
        response.campaign_reports.length > 0
      ) {
        $scope.socialRetargetingStatus = true;
        $scope.social_retargeting_chart_data = HubCharts.social_retargeting_chart(
          response.campaign_reports,
          response.campaign_report
        );
      }
    };
    /// eof social_retargeting
    /// review
    $scope.init_review_page = function() {
      Business.reviews_by_stars({ id: params.id, dashboard: 'new' }, function(
        response
      ) {
        if (response.status == 200) {
          $scope.reviewsData(response.data);
        } else {
          $scope.reviewStatus = false;
        }
      });
    };

    $scope.reviewsData = function(response) {
      $scope.reviewStatus = true;
      $scope.star_counts = response;
      stars = _.toArray($scope.star_counts);
      $scope.reviewChartData = HubCharts.ratings_bar_chart(_.toArray(stars));
    };

    /// eof Review
    //// visitors
    $scope.init_visitors_page = function() {
      Business.google_analytics_overview(params, function(response) {
        if (response.status == 200) {
          $scope.visitorsData(response.data);
        } else {
          $scope.visitorsStatus = false;
        }
      });
    };

    $scope.visitorsData = function(response) {
      $scope.visitorsStatus = true;
      $scope.analytics = response.totals;
      $scope.visitor_chart_data = HubCharts.visitors_pie_chart_data(
        response.visit_status
      );
    };
    /// eof visitors
    $scope.resize = function() {
      $scope.size = window.innerWidth;
    };
    $interval($scope.resize, 100);
    $scope.$watch('size', function(newValue, oldValue) {
      if (newValue != oldValue) {
        resizeAllCharts();
      }
    });

    $rootScope.competitors_service_enabled = 'true';

    if ($rootScope.first_time_user) {
      var clickxTour = {
        id: 'Clickx-tour',
        showPrevButton: true,
        skipIfNoElement: true,
        steps: [
          {
            title: 'Marketing Performance',
            content:
              'Your marketing performance denoted by graphs of traffic, contacts, and growth metrics.',
            target: 'onboarding-marketing-performance',
            placement: 'bottom'
          },
          {
            title: 'Google Analytics',
            content:
              'Displays the analytics of the traffic on your site as per Google Analytics.',
            target: 'onboarding-google-analytics',
            placement: 'bottom'
          },
          {
            title: 'Keyword Ranking',
            content:
              'Graph showing the number of keywords your site is ranking for and also the position of keywords in Google SERP over time.',
            target: 'onboarding-keywords',
            placement: 'bottom'
          },
          {
            title: 'Best Performing Ads',
            content: 'List of best performing ads',
            target: 'onboarding-best-ads',
            placement: 'bottom'
          },
          {
            title: 'Backlinks',
            content:
              'Denotes the Trust Flow, Citation Flow, number of backlinks, and referring domains of your site. For a full report, go to backlinks in the "SEO" section.',
            target: 'onboarding-backlinks',
            placement: 'bottom'
          },
          {
            title: 'Google Ads',
            content:
              'Graph denoting the clicks you received on your Google AdWords PPC keywords, impressions, and conversions. You can also view the full report in PPC Reports in the "Ads" section in the sidebar.',
            target: 'onboarding-adwords',
            placement: 'bottom'
          },
          {
            title: 'Call Analytics',
            content:
              'Graph denoting the nature of phone calls made your company. For more information go to call analytics in the "Analytics" section.',
            target: 'onboarding-call-analytics',
            placement: 'bottom'
          },
          {
            title: 'Competitors',
            content:
              'List of your competitors who have similar traffic to your site\'s traffic. For more competitor reports, go to the "Competitors" section in the sidebar.',
            target: 'onboarding-competitors',
            placement: 'bottom'
          },
          {
            title: 'Contacts by source',
            content:
              'For more details, go to web analytics in the "Analytics" section in the sidebar.',
            target: 'onboarding-contacts-by-source',
            placement: 'bottom'
          },
          {
            title: 'Contacts per day',
            content:
              'A graph showing the number of contacts you\'re getting on a daily basis. For a list of all contacts, go to the "Contacts" section in the sidebar.',
            target: 'onboarding-contacts-per-day',
            placement: 'bottom'
          },
          {
            title: 'Google Search Console',
            content:
              'Graph denoting the keyword ranking position, impressions on your site, clicks and CTR.',
            target: 'onboarding-google-search-console',
            placement: 'bottom'
          },
          {
            title: 'Recent Contacts',
            content: 'List of most recent contacts',
            target: 'onboarding-recent-contacts',
            placement: 'bottom'
          },
          {
            title: 'Reviews',
            content:
              'Overview of the ratings and reviews you got on your site. For more, go to reputation management under the "Locals" section.',
            target: 'onboarding-reviews',
            placement: 'bottom'
          },
          {
            title: 'Social Retargeting',
            content:
              'Denotes the impressions, clicks and cost of the retargeting ads you are running on Facebook. Data is provided by Perfect Audience.',
            target: 'onboarding-social-retargeting',
            placement: 'bottom'
          },
          {
            title: 'Top Keywords',
            content:
              'List of top 10 keywords. For more keywords, go to keywords in the "SEO" section in the sidebar.',
            target: 'onboarding-top-10-keywords',
            placement: 'bottom'
          },
          {
            title: 'Source of Visitors',
            content: 'List of sources where your visitors come from',
            target: 'onboarding-visitors',
            placement: 'bottom'
          }
        ]
      };
      hopscotch.startTour(clickxTour);
    }
    if (current_intelligence_enabled) $scope.init_intelligence_dashlets();
  }
]);
