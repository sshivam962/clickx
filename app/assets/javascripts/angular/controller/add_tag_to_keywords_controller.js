clickxApp.controller('addTagToKeywords', [
  '$scope',
  '$mdDialog',
  'data',
  'Business',
  '$rootScope',
  '$timeout',
  function($scope, $mdDialog, data, Business, $rootScope, $timeout) {
    var colors = ['#808080', '#000000', '#FF0000', '#800000', '#FFFF00',
      '#00FF00', '#008000', '#00FFFF', '#008080', '#0000FF', '#FF00FF', '#800080'];
    $scope.available_data = (_.difference(data.all_keywords, data.selected_keywords)).slice();
    $scope.keywords_to_be_tagged = (data.selected_keywords).slice();
    $scope.searchText = ' ';
    $timeout(function() {
      $scope.searchText = '';
    });

    $scope.refreshAvailableKeywords = function() {
      $scope.available_data = _.difference(data.all_keywords, $scope.keywords_to_be_tagged);
    };

    $scope.keyword_tags = [];

    $scope.selectTag = function(tag) {
      $scope.keyword_tags.push(tag);
      $scope.refreshAvailableTags();
    };

    $scope.getTags = function() {
      Business.all_keyword_tags(
        {
          id: current_business
        },
        function(result) {
          $scope.all_keyword_tags = result.businesses_keyword_tags;
          $scope.available_tags = $scope.all_keyword_tags.slice();
        },
        function(error) {}
      );
    };

    $scope.refreshAvailableTags = function() {
      $scope.available_tags = _.difference($scope.all_keyword_tags, $scope.keyword_tags);
    };

    $scope.getTags();
    $scope.ok = function() {
      if($('#searchTag').val()) {
        $scope.keyword_tags = [
          {
            name: $('#searchTag').val(),
            color: colors[Math.floor(Math.random() * 12)]
          }
        ];
      }
      if (!$scope.keywords_to_be_tagged.length) {
        toastr.warning('Please select some keywords');
        return;
      }
      if (!$scope.keyword_tags.length) {
        toastr.warning('Please enter or select a tag');
        return;
      }

      $.each($scope.keyword_tags, function(index, tag) {
          tag.business_id = current_business
      });

      var formData = {
        tags: $scope.keyword_tags,
        id: data.business_id,
        business_keyword_ids: _.pluck($scope.keywords_to_be_tagged, 'id')
      };
      try {
        Business.tag_keywords(
          formData,
          function(result) {
            if (result.status === 200) {
              $rootScope.keywords = $rootScope.all_keywords = _.map(
                $rootScope.keywords,
                function(keyword) {
                  if (_.contains(formData.business_keyword_ids, keyword.id)) {
                    keyword.tags = result.tags;
                  }
                  return keyword;
                }
              );
              $mdDialog.hide('success');
            } else {
              toastr.warning(result.errors);
            }
          },
          function(error) {}
        );
      } catch (error) {}
    };
    $scope.close = function() {
      $mdDialog.cancel('cancel');
    };
    $scope.selectAll = function() {
      $scope.keywords_to_be_tagged = (data.all_keywords).slice();
      $scope.available_data = [];
    };
    $scope.deselectAll = function() {
      $scope.keywords_to_be_tagged = [];
      $scope.available_data = (data.all_keywords).slice();
    };

    $scope.transformChip = function(chip) {
      if (angular.isObject(chip)) {
        return chip;
      }

      return { name: chip, color: colors[Math.floor(Math.random() * 12)] };
    };
  }
]);
