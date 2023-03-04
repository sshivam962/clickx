clickxApp.controller('potentialKeywordsCtrl', [
  '$scope',
  'Business',
  '$timeout',
  function($scope, Business, $timeout) {
    $scope.keywords = {};
    Business.potential_keywords(
      {
        id: current_business
      },
      function(result) {
        $scope.organicKeywords = result.organic;
        $scope.allOrganicKeywords = $scope.organicKeywords;
        $scope.paidKeywords = result.paid;
        $scope.allPaidKeywords = $scope.paidKeywords;
      },
      function(error) {
        toastr.error(error.statusText, 'error');
      }
    );

    var saveKeyword = function(name, current_index, type) {
      Business.add_to_keyword_bank(
        {
          id: current_business
        },
        { keyword: name },
        function(result) {
          if (result.status == 201) {
            $timeout(function() {
              toastr.success('Keyword added to Queue', 'success');
              $scope[type].splice(current_index, 1);
            });
          } else {
            toastr.warning(result.error, 'error');
          }
        }
      );
    };

    $scope.addToKeyword = function(current_index, type) {
      var keyword = $scope[type][current_index].keyword;
      $scope.filterData = {
        id: current_business,
        time_string: 'all_time',
        limit: 1000,
        offset: 0,
        sort: 'googleRanking',
        sort_order: false
      };
      Business.business_keywords(
        $scope.filterData,
        function(result) {
          $scope.keywords.keywords_limit = result.keyword_limit;
          $scope.keywords.remaining_count =
            result.keyword_limit - result.total_size;
          $timeout(function() {
            if ($scope.keywords.remaining_count == 0) {
              toastr.warning(
                'Keyword limit exceeded!',
                'You may have to delete some keywords if you want to add more'
              );
            } else {
              if (!_.isEmpty(keyword)) {
                try {
                  $scope.adding_kw_length = keyword
                    .split(/\r\n|\r|\n/)
                    .filter(Boolean).length;
                  if (
                    $scope.keywords.remaining_count > $scope.adding_kw_length
                  ) {
                    var items = keyword.length > 0 ? keyword.split(/\n/) : [];
                    var exisitngKeywords = _.map(result.data, function(
                      keyword,
                      index
                    ) {
                      return keyword.name;
                    });
                    items.forEach(function(item, index) {
                      if (
                        _.indexOf(exisitngKeywords, item.toLowerCase()) != -1
                      ) {
                        toastr.warning(item + ' already exists', 'warning');
                      } else {
                        saveKeyword(items, current_index, type);
                      }
                    });
                  } else {
                    toastr.warning('Keyword limit exceeded!', 'warning');
                  }
                } catch (e) {}
              }
            }
          }, 10);
        },
        function(error) {}
      );
    };
  }
]);
