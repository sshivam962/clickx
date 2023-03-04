clickxApp.controller('AdwordSelectAccountsController', [
  '$scope',
  '$routeParams',
  'Business',
  '$mdDialog',
  '$window',
  '$rootScope',
  'ThirdPartyIntegrationService',
  '$q',
  function(
    $scope,
    $routeParams,
    Business,
    $mdDialog,
    $window,
    $rootScope,
    ThirdPartyIntegrationService,
    $q
  ) {
    $scope.accounts = [];
    $scope.service = $routeParams.service;
    var update_property = $routeParams.service + '_client_id';

    $scope.getAdwordsAccounts = function() {
      Business.adwords_connect_account(
        { type: $routeParams.service },
        {},
        function(response) {
          $scope.accounts = response;
        }
      );
    };

    $scope.getAdwordsAccounts();

    $scope.selectMe = function(account) {
      $scope.selected = account;
    };

    $scope.saveAccount = function() {
      var params = {};
      params[update_property] = $scope.selected.customer_id || '';
      Business.update_business(
        { id: $rootScope.current_business },
        { business: params },
        function(response) {
          updateAccountDetails(
            $scope.selected.name,
            'adwords_' + $scope.service
          );
          $rootScope.initializeBusiness(response.business);
          toastr.success('Ad Client Updated', 'Success');
        }
      );
    };

    var updateAccountDetails = function(info, name) {
      $scope.integrationDetails().then(function() {
        var params = {
          details: $rootScope.details || {}
        };
        params['details'][name] = info;
        ThirdPartyIntegrationService.update(
          {
            business_id: $rootScope.current_business
          },
          params,
          function(response) {
            $rootScope.detail = response.details;
            $window.location.href = '/#/integrations';
          },
          Utility.logError
        );
      });
    };

    $scope.integrationDetails = function() {
      var deferred = $q.defer();
      Business.integration_details(
        {
          id: current_business
        },
        function(result) {
          deferred.resolve(result);
          $rootScope.details = result.details || {};
        },
        Utility.logError
      );
      return deferred.promise;
    };
  }
]);
