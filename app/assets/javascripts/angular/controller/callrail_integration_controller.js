clickxApp.controller('CallRailIntegrationController', [
  '$scope',
  '$rootScope',
  'Business',
  '$q',
  '$mdDialog',
  'ThirdPartyIntegrationService',
  function(
    $scope,
    $rootScope,
    Business,
    $q,
    $mdDialog,
    ThirdPartyIntegrationService
  ) {
    $scope.business = $rootScope.business;
    $scope.callrail_api_key = $scope.business.callrail_id;
    $scope.callrail_account_id_dup = $scope.business.callrail_account_id;

    $scope.authenticateCallrail = function(business) {
      Business.callrail_authenticate(
        {},
        {
          id: $scope.business.id,
          callrail_id: business.callrail_id
        },
        function(result) {
          $scope.business = result.business;
          $scope.callrail_api_key = result.business.callrail_id;
          toastr.success('CallRail authentcaton successful');
        },
        function(error) {
          toastr.error('Inavlid API KEY');
          $mdDialog.cancel();
        }
      );
    };

    $scope.getAccounts = function() {
      Business.call_rail_accounts({}, { id: $scope.business.id }, function(
        result
      ) {
        $scope.accounts = result.accounts;
        var selectedAccount = _.find($scope.accounts, function(account) {
          return account.id == $scope.business.callrail_account_id;
        });
      });
    };

    $scope.saveDetails = function() {
      $scope.updateBusiness($scope.business);
      $mdDialog.cancel();
    };

    $scope.selectDetails = function(type, value) {
      updateAccountDetails(value.name, 'callrail_name');
      $scope.business[type] = value.id;
      $scope.callrail_account_id_dup = value.id;
      $scope.updateBusiness($scope.business).then(function() {
        window.location.href = '/b/callrail';
      });
    };

    $scope.clearData = function() {
      $scope.accounts = [];
      $scope.selectedCompany = '';
      $scope.selectedAccount = '';
    };

    $scope.integrateCallRail = function(business) {
      $scope.clearData();
      $scope.getAccounts();
    };

    $scope.updateBusiness = function(params) {
      var deferred = $q.defer();
      Business.update_business({ id: $scope.business.id }, params, function(
        response
      ) {
        toastr.success('Account updated successfully', 'Success!');
        $mdDialog.cancel();
        deferred.resolve(response);
      });
      return deferred.promise;
    };

    var updateAccountDetails = function(info, name) {
      var params = {
        details: $rootScope.details
      };
      params['details'][name] = info;
      ThirdPartyIntegrationService.update(
        {
          business_id: $rootScope.current_business
        },
        params,
        function(response) {
          $rootScope.detail = response.details;
        },
        Utility.logError
      );
    };
  }
]);
