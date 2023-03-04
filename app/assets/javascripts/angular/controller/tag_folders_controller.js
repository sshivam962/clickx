clickxApp.controller('tagFolder', [
  '$scope',
  'Business',
  '$rootScope',
  '$mdDialog',
  function($scope, Business, $rootScope, $mdDialog) {
    $scope.business_id = $rootScope.current_business;
    var keywordParams = {
      limit: 50,
      offset: 0,
      sort: 'googleRanking',
      sort_order: 'false',
      time_string: 'all_time',
      id: current_business
    };

    $scope.getAllTags = function() {
      Business.all_keyword_tags(
        {
          id: $scope.business_id
        },
        function(result) {
          $scope.tags = result.businesses_keyword_tags;
        },
        function(error) {}
      );
    };
    $scope.getAllTags();
    $scope.deleteTag = function(tag) {
      Business.delete_keyword_tag(
        {
          tag_id: tag,
          id: $scope.business_id
        },
        function(success) {
          $scope.getAllTags();
          $rootScope.keywordResult = Business.business_keywords(keywordParams);
          toastr.success('Deleted the tag', 'Success');
        }
      );
    };
    $scope.addTag = function() {
      $scope.editTag({ name: '', color: '#0074D9' });
    };

    $scope.editTag = function(tag) {
      $mdDialog
        .show({
          templateUrl: 'themeX/keywords/_edit_tags.html',
          controller: 'editTagsController',
          resolve: {
            data: function() {
              return {
                business_id: $scope.business_id,
                tag: tag
              };
            }
          }
        })
        .then(
          function(result) {
            $scope.getAllTags();
          },
          function(cancel) {}
        );
    };
  }
]);
