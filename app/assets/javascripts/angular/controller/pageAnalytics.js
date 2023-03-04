clickxApp.controller('pageAnalytics', [
  '$scope',
  '$routeParams',
  'SiteAuditService',
  '$window',
  '$localStorage',
  function($scope, $routeParams, SiteAuditService, $window, $localStorage) {
    $scope.page_uri = angular.fromJson(localStorage.getItem($routeParams.business_id));
    $scope.params = {
      id: $routeParams.business_id,
      url: $scope.page_uri,
      issue_id: angular.fromJson(localStorage.getItem('current_site_audit_issue'))
    };
    $scope.paginationStart = 0;
    $scope.limit_backlink_rows = 25;
    $scope.limit_keyword_rows = 25;
    $scope.edit_error = false;
    $scope.backlinkEnable = true;
    $scope.keywordsEnable = true;
    $scope.role = commonGetCookies('admin_id');
    $scope.excludeKeys = [
      'error_description',
      'error_title',
      'passed_description',
      'passed_title',
      'status',
      'issue_type'
    ];
    $scope.excludePageKeys = [
      'broken_links',
      'non_200_pages',
      'server_errors',
      'redirection_301_links',
      'non_301_redirection_links'
    ];
    $scope.checkKeys = function(key, array) {
      return _.contains($scope[array], key);
    };
    $scope.blockTitle = [
      { title: 'Title', src: 'themeX/site_audits/_title.html' },
      { title: 'Description', src: 'themeX/site_audits/_description.html' },
      { title: 'H-Tags', src: 'themeX/site_audits/_htags.html' },
      { title: 'Images', src: 'themeX/site_audits/_images.html' },
      { title: 'CTA', src: 'themeX/site_audits/_cta.html' },
      { title: 'Page Links', src: 'themeX/site_audits/_page_links.html' }
    ];

    $scope.templates = ['errors', 'backlinks', 'keywords'];
    $scope.loadTemplate = function(src) {
      $scope.settings_tab = src;
      $scope.current_template = 'themeX/site_audits/' + src + '.html';
    };

    SiteAuditService.page_error($scope.params, function(result) {
      if (result.data) {
        $scope.lists = result.data[0];
        $scope.title = $scope.lists.title;
        $scope.description = $scope.lists.description;
        $scope.htags = $scope.lists.h_tags;
        $scope.images = $scope.lists.images;
        $scope.page_links = $scope.lists.page_links;
        $scope.cta = $scope.lists.cta;
        $scope.error = result.errors_count;
        $scope.passed = result.passed;
        $scope.warning = result.warning_count;
        $scope.csvExport = result.url;
        $scope.wrapKeyWord();
      } else {
        $scope.uncrawled = result.error;
      }
      $scope.updated_at = result.updated_at;
    });

    var setPagination = function(tableState, pagination, totalSize, params) {
      tableState.pagination['to'] = Math.min(
        pagination.start + pagination.number,
        totalSize || 0
      );
      $scope.paginationStart = pagination.start || 0;
      tableState.pagination.total_pages = totalSize || 0;
      tableState.pagination.numberOfPages = Math.ceil(totalSize / params.limit);
      $scope.loadingTable = false;
    };

    var stSearch = function(tableState) {
      if (
        tableState.search &&
        tableState.search.predicateObject &&
        tableState.search.predicateObject.$
      ) {
        $scope.params['search'] = tableState.search.predicateObject.$;
      } else {
        if ($scope.params['search']) delete $scope.params['search'];
      }
    };

    $scope.stTableServerKeyword = function(tableState) {
      $scope.loadingTable = true;
      var pagination = tableState.pagination;
      $scope.params['offset'] = pagination.start || 0;
      $scope.params['limit'] = pagination.number || 5;
      $scope.limit_keyword_rows = pagination.number;
      stSearch(tableState);
      SiteAuditService.ranking($scope.params, function(result) {
        $scope.keywords = result.data;
        if (!$scope.keywords) {
          $scope.keywordsEnable = false;
        }
        $scope.totalKeywordSize = result.total_size;
        setPagination(
          tableState,
          pagination,
          $scope.totalKeywordSize,
          $scope.params
        );
      });
    };

    $scope.stTableServer = function(tableState) {
      $scope.loadingTable = true;
      var pagination = tableState.pagination;
      $scope.params['offset'] = pagination.start || 0;
      $scope.params['limit'] = pagination.number || 25;
      $scope.limit_backlink_rows = pagination.number;
      SiteAuditService.backlink($scope.params, function(result) {
        $scope.backlinks = result.data;
        if (!$scope.backlinks) {
          $scope.backlinkEnable = false;
        }
        $scope.totalBacklinkSize = result.total_size;
        setPagination(
          tableState,
          pagination,
          $scope.totalBacklinkSize,
          $scope.params
        );
      });
    };

    $scope.doneEditInfo = function(error) {
      SiteAuditService.edit_error(
        $scope.params,
        {
          data: error
        },
        function(result) {
          toastr.success('Info updated', 'Success');
        }
      );
    };

    $.fn.wrapFoundWords = function(opts) {
      var tag = opts.tag;
      var words = opts.words;
      var regex = RegExp(words.join('|'), 'gi');
      var replacement = '<' + tag + " class='text-dark' >$&</" + tag + '>';
      return this.html(function() {
        return $(this)
          .text()
          .replace(regex, replacement);
      });
    };
    var wrapword = function() {
      extractKeywordsFromSource = function() {
        var keywords = [];
        $.each($('.source'), function() {
          keywords.push($.trim($(this).text()));
        });
        return keywords;
      };

      var words = extractKeywordsFromSource();

      $('.destination').wrapFoundWords({
        tag: 'b', // b -> bold (html tag)
        words: words // array
      });
    };

    $scope.wrapKeyWord = function() {
      var setTime = setInterval(function() {
        if ($('.source').length) {
          wrapword();
          clearInterval(setTime);
        }
      }, 300);
    };
  }
]);
