clickxApp.controller('editTagsController', [
  '$scope',
  '$mdDialog',
  'data',
  'Business',
  '$rootScope',
  function($scope, $mdDialog, data, Business, $rootScope) {
    $scope.tag = data.tag;
    var keywordParams = {
      limit: 50,
      offset: 0,
      sort: 'googleRanking',
      sort_order: 'false',
      time_string: 'all_time',
      id: current_business,
      ignoreLoadingBar: true
    };

    $scope.colors = [
      '#0074D9',
      '#001F3F',
      '#FF4136',
      '#39CCCC',
      '#FF851B',
      '#2ECC40',
      '#F012BE',
      '#FFDC00'
    ];

    $scope.ok = function() {
      try {
        if ($scope.tag.id) {
          Business.edit_keyword_tag(
            {
              id: data.business_id,
              tag: $scope.tag,
              tag_id: $scope.tag.id
            },
            function(result) {
              toastr.success('Tag Updated');
              $rootScope.keywordResult = Business.business_keywords(
                keywordParams
              );
            },
            function(error) {
              console.log(error);
            }
          );
        } else {
          Business.new_keyword_tag(
            {
              id: data.business_id,
              tag: $scope.tag
            },
            function(result) {
              toastr.success('Tag Created');
            },
            function(error) {
              console.log(error);
            }
          );
        }
        $scope.tag = {};
        $mdDialog.hide('success');
      } catch (error) {
        console.log(error);
      }
    };

    $scope.close = function() {
      $scope.tag = {};
      $mdDialog.cancel('cancel');
    };

    $scope.selectTagcolor = function(color) {
      $scope.tag.color = color;
      $scope.setTagColorFalse();
      $scope.filter[color] = true;
    };

    $scope.setTagColorFalse = function() {
      $scope.filter = {
        '#0074D9': false,
        '#001F3F': false,
        '#FF4136': false,
        '#39CCCC': false,
        '#FF851B': false,
        '#2ECC40': false,
        '#F012BE': false,
        '#FFDC00': false
      };
    };

    $scope.setTagColorFalse();
    $scope.filter[$scope['tag']['color']] = true;
  }
]);
