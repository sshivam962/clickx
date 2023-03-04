clickxApp.controller('SearchTerm', [
  '$scope',
  '$rootScope',
  '$resource',
  '$routeParams',
  '$mdDialog',
  'SearchTerms',
  'Business',
  function(
    $scope,
    $rootScope,
    $resource,
    $routeParams,
    $mdDialog,
    SearchTerms,
    Business
  ) {
    $scope.sort_by = '-updated_at';
    $scope.per_page = 10;

    $scope.sort_order = {
      name: '',
      locale: '',
      city: ''
    };

    $scope.openCreateKeywordModal = function() {
      $mdDialog.show({
        scope: $scope,
        preserveScope: true,
        templateUrl: 'create-keyword.html',
        locals: {},
        controller: 'NewSearchTerm'
      });
    };

    $scope.search_terms = function() {
      SearchTerms.search_terms({}, function(response) {
        $scope.keywords = response.data;
        $scope.getCountryLocaleForKeywords();
      });
    };

    var fetchSearchTerms = function(params, tableState) {
      params['sort'] = $scope.sort_by;
      SearchTerms.search_terms(params, function(response) {
        $scope.result = response.data;
        $scope.keywords = response.data.search_terms;
        $scope.getCountryLocaleForKeywords();
        $scope.tableState = tableState;
        if (typeof tableState != 'undefined') {
          tableState.pagination['numberOfPages'] = response.data.total_pages;
        }
      });
    };

    var params = {};
    $scope.fetchKeywordData = function(tableState) {
      $scope.tableState = tableState || {};
      var currentPage =
        tableState.pagination.start / tableState.pagination.number;
      params['page'] = currentPage + 1 || 1;
      params['per_page'] = tableState.pagination.number || $scope.per_page;
      params['page[number]'] = params.page;
      params['page[size]'] = params.per_page;
      if ($scope.dateChangeDetect) {
        params['page[number]'] = 1;
        params['page[size]'] = $scope.per_page;
        tableState.pagination.start = 0;
        $scope.dateChangeDetect = false;
      }
      // Search
      if (
        tableState.search &&
        tableState.search.predicateObject &&
        tableState.search.predicateObject.$
      ) {
        params['search'] = tableState.search.predicateObject.$;
      } else {
        if (params['search']) delete params['search'];
      }
      delete params.per_page;
      delete params.page;
      if (tableState.sort) {
        if (tableState.sort.predicate) {
          params['sort'] =
            (tableState.sort.reverse ? '-' : '') + tableState.sort.predicate;
        } else {
          delete params['sort'];
        }
      }
      fetchSearchTerms(params, tableState);
    };

    $scope.sortBy = function(param) {
      for (var key in $scope.sort_order) {
        if (key != param) {
          $scope.sort_order[key] = '';
        }
      }
      $scope.sort_order[param] = !$scope.sort_order[param];
      $scope.sort_by = $scope.sort_order[param] ? param : '-' + param;
      $scope.$broadcast('triggerSTTable');
    };

    $scope.create = function() {
      SearchTerms.create_serach_term({ keyword: $scope.keyword }, function(
        response
      ) {
        if (response.status == 200) {
          $scope.closeModal();
          $scope.search_terms();
        } else {
          toastr.error(response.message);
        }
      });
    };

    $scope.deleteThisKeyword = function(id) {
      SearchTerms.delete_search_term({ id: id }, function(response) {
        if (response.status == 200) {
          $('#keyword_' + id).hide();
          toastr.success(response.message);
        } else {
          toastr.error(response.message);
        }
      });
    };

    $scope.deleteKeyword = function(id) {
      var confirm = $mdDialog
        .confirm()
        .title('Delete this Keyword')
        .textContent('Are you sure?')
        .ok('Yes')
        .cancel('Cancel');

      $mdDialog.show(confirm).then(
        function() {
          $scope.deleteThisKeyword(id);
        },
        function() {}
      );
    };

    $scope.getCountryLocaleForKeywords = function() {
      Business.country_locale(function(response) {
        $rootScope.countryList = response.data;
        $.each($scope.keywords, function(i, kw) {
          kw['locale'] = $scope.getCountryFromLocale(kw.locale);
        });
      });
    };
  }
]);

clickxApp.controller('RankingPositions', [
  '$scope',
  '$rootScope',
  '$resource',
  '$routeParams',
  'SearchTerms',
  function($scope, $rootScope, $resource, $routeParams, SearchTerms) {
    $scope.export_pdf = '/search_terms/' + $routeParams.id +'.pdf?business_id=' + $rootScope.current_business;
    $scope.csv_url = '/search_terms/' + $routeParams.id +'.csv?business_id=' + $rootScope.current_business;

    $scope.getKeyword = function() {
      SearchTerms.get_search_term({ id: $routeParams.id }, function(response) {
        $scope.search_term = response.data.search_term;
        $scope.latest_rankings = response.data.latest_rankings;
      });
    };

    $scope.getKeyword();
  }
]);

clickxApp.controller('NewSearchTerm', [
  '$scope',
  '$rootScope',
  '$resource',
  '$routeParams',
  '$mdDialog',
  'SearchTerms',
  'Business',
  function(
    $scope,
    $rootScope,
    $resource,
    $routeParams,
    $mdDialog,
    SearchTerms,
    Business
  ) {
    $scope.closeModal = function() {
      $mdDialog.cancel('cancel');
    };

    $scope.setLocation = function() {
      var country = $scope.getCountryFromLocale($scope.keyword.locale);
      var country_code = $scope.getCountryCodeFromLocale($scope.keyword.locale);
      $scope.options = {
        types: ['(regions)'],
        componentRestrictions: {
          country: country_code
        }
      };
      $scope.keyword.city = country;
    };

    $scope.keyword = { name: '' };

    if ($rootScope.business) {
      $scope.keyword.city = $rootScope.business.target_city;
      $scope.options = {
        types: ['(regions)'],
        componentRestrictions: {
          country: $scope.getCountryCodeFromLocale($rootScope.business.locale)
        }
      };
    }
  }
]);
