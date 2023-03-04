clickxApp.controller('KeywordTrash', [
  '$scope',
  'Business',
  function($scope, Business) {
    Business.deleted_business_keywords(function(response) {
      $scope.deleted_keywords = response;
    });
  }
]);
