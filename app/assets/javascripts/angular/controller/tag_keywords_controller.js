clickxApp.controller('tagKeywords', [
  '$scope',
  'Business',
  '$routeParams',
  '$rootScope',
  function($scope, Business, $routeParams, $rootScope) {
    $rootScope.business_id = $routeParams.business_id;
    try {
      $scope.keywords = [];
      $scope.business_id = $rootScope.business_id || $routeParams.business_id;
      Business.keywords_in_tag(
        {
          id: $scope.business_id,
          tag_id: $routeParams.tag_id
        },
        function(result) {
          $scope.keywords = result.data;
          $scope.tag = result.tag;
        },
        function(error) {
          toastr.error(error.statusText);
        }
      );
    } catch (error) {
      toastr.error(error.message);
    }
    $scope.untagSelectedKeyword = function(event) {
      untagKeywords = [];
      $('.keyword-checkbox:checked').each(function(index, element) {
        untagKeywords.push($(element).val());
      });
      Business.untag_business_keyword(
        {
          id: $rootScope.business_id,
          tag_id: $routeParams.tag_id,
          biz_keyword_ids: untagKeywords
        },
        function(result) {
          untagKeywords = [];
          Business.keywords_in_tag(
            {
              id: $scope.business_id,
              tag_id: $routeParams.tag_id
            },
            function(result) {
              $scope.keywords = result.data;
            },
            function(error) {
              toastr.error(error.statusText);
            }
          );
        },
        function(error) {
          untagKeywords = [];
        }
      );
    };

    $scope.toggleKeywordSelect = function(event) {
      if (event.target.checked) {
        $('.keyword-checkbox').prop('checked', true);
      } else {
        $('.keyword-checkbox').prop('checked', false);
      }
    };
  }
]);
