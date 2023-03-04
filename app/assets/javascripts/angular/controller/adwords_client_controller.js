clickxApp.controller('AdwordsClientController', [
  '$scope',
  '$routeParams',
  'Business',
  '$mdDialog',
  'service',
  'accounts',
  'business',
  function(
    $scope,
    $routeParams,
    Business,
    $mdDialog,
    service,
    accounts,
    business
  ) {
    $scope.current_service = service;
    $scope.business = business;
    var update_property = service + '_client_id';
    $scope.accounts = accounts;
    $scope.selectedAccount = _.find($scope.accounts, function(account) {
      return account.customer_id == $scope.business[update_property];
    });
    $scope.selectAccount = function(account) {
      var params = {};
      params[update_property] = account.customer_id;
      Business.update_business(
        { id: $routeParams.business_id },
        { business: params },
        function() {
          toastr.success('Ad Client Updated', 'Success');
          $mdDialog.cancel();
        }
      );
    };
    $scope.updateClient = function(client) {
      $scope.selectedAccount = client;
    };
  }
]);
