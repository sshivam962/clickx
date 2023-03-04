clickxApp.controller('BusinessAddUser', [
  '$scope',
  '$rootScope',
  '$resource',
  '$http',
  'Business',
  '$location',
  '$upload',
  '$routeParams',
  function(
    $scope,
    $rootScope,
    $resource,
    $http,
    Business,
    $location,
    $upload,
    $routeParams
  ) {
    $scope.business = Business.get({ id: $routeParams.id });
    $rootScope.current_controller = 'businesses';

    $scope.update = function() {
      if ($scope.businessForm.$valid) {
        if ($rootScope.logo != '') {
          $scope.business.logo = $rootScope.logo;
        }

        Businesses.create(
          { business: $scope.business },
          function() {
            $rootScope.logo = '';
            $rootScope.flash = {};
            $rootScope.flash.message = 'Business Created Successfully';

            $location.path('/businesses');
          },
          function(error) {
            console.log(error);
          }
        );
      }
    };
  }
]);
