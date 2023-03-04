clickxApp.controller('SiteAudit', [
  '$scope',
  'SiteAuditService',
  '$window',
  '$localStorage',
  function($scope, SiteAuditService, $window, $localStorage) {
    $scope.businessId = current_business;
    $scope.paginationStart = 0;
    $scope.limit_overview_rows = 1;
    $scope.sort_by = 'traffic_metrics';
    $scope.sort_by_item = {
      traffic_metrics: 'Visits',
      errors_count: 'Errors',
      keywords: 'keywords',
      backlinks_count: 'Links',
      readability_score: 'Readability',
      warning_count: 'Warnings'
    };
    $scope.params = {
      id: $scope.businessId
    };
    $scope.templates = ['pages', 'site_overview'];
    $scope.loadTemplate = function(src) {
      $scope.settings_tab = src;
      $scope.current_template = 'themeX/site_audits/' + src + '.html';
    };

    $scope.stTableServer = function(tableState) {
      $scope.loadingTable = true;
      var pagination = tableState.pagination;
      $scope.params['offset'] = pagination.start || 0;
      $scope.params['limit'] = pagination.number || 1;
      $scope.limit_overview_rows = pagination.number;
      if (
        tableState.search &&
        tableState.search.predicateObject &&
        tableState.search.predicateObject.$
      ) {
        $scope.params['search'] = tableState.search.predicateObject.$;
      } else {
        if ($scope.params['search']) delete $scope.params['search'];
      }
      SiteAuditService.query(
        $scope.params,
        function(result) {
          $scope.overViews = result.data;
          $scope.updated_at = result.updated_at;
          $scope.totalPageSize = result.total_size;
          $scope.paginationStart = pagination.start || 0;
          tableState.pagination.total_pages = result.total_size || 0;
          if ($scope.params['limit'] == 1) {
            tableState.pagination['to'] = result.total_size || 0;
            tableState.pagination.numberOfPages = 1;
          } else {
            tableState.pagination['to'] = Math.min(
              pagination.start + pagination.number,
              result.total_size || 0
            );
            tableState.pagination.numberOfPages = Math.ceil(
              result.total_size / $scope.params.limit
            );
          }
          $scope.loadingTable = false;
        },
        function(error) {
          if (error.data.message) {
            $scope.uncrawled = error.data.message;
          }
        }
      );
    };

    SiteAuditService.optimization(
      {
        id: $scope.businessId
      },
      function(result) {
        var analytic = result.data;
        $scope.sslCheck = analytic.ssl.response.data;
        $scope.sslStatus = analytic.ssl.status;
        $scope.versionCheck = analytic.version.response.data;
        $scope.versionStatus = analytic.version.status;
        $scope.siteMap = analytic.xml.response.data;
        $scope.siteMapStatus = analytic.xml.status;
        $scope.robotsTxt = analytic.robots.response.data;
        $scope.robotsStatus = analytic.robots.status;
      }
    );

    var html =
      "<tr class='error-append-msg'>" +
      "<td colspan = '9'>" +
      "<div class='alert alert-warning alert-dismissable fade in'>" +
      "<a class='close'>×</a>" +
      "<p class='text-center'>This page on your site might not be crawled, or blocked our crawler.</p>" +
      '  </div>' +
      '</td>' +
      '</tr>';

    $scope.viewError = function($event, issue) {
      $window.localStorage.setItem(
        'current_site_audit_issue',
        angular.toJson(issue.id)
      );
      if (
        issue.errors_count ||
        issue.warning_count ||
        issue.readability_score
      ) {
        $window.localStorage.setItem(
          $scope.businessId,
          JSON.stringify(issue.url)
        );
        window.location.href = '/#/' + $scope.businessId + '/page_analytics';
      } else {
        $('.error-append-msg').remove();
        $(html).insertAfter(
          $($event.currentTarget)
            .parent()
            .parent()
        );

        var timer = setTimeout(function() {
          $('.error-append-msg').fadeOut();
        }, 3000);

        $('.close').click(function() {
          $('.error-append-msg').remove();
        });

        $('.error-append-msg').hover(
          function() {
            clearTimeout(timer);
          },
          function() {
            $('.error-append-msg').fadeOut();
          }
        );
      }
    };
  }
]);
