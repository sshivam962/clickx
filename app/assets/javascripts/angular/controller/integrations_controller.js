clickxApp.controller('Integrations', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  '$location',
  'Business',
  'Businesses',
  '$mdDialog',
  '$timeout',
  '$window',
  'ThirdPartyIntegrationService',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    $location,
    Business,
    Businesses,
    $mdDialog,
    $timeout,
    $window,
    ThirdPartyIntegrationService
  ) {
    $rootScope.current_controller = 'integrations';
    $scope.biz = {};
    $scope.filter = { all: true };

    $scope.setDisplaySectionsFalse = function() {
      $scope.filter = {
        all: false,
        crm: false,
        marketing: false,
        emailProviders: false,
        ads: false,
        call: false,
        forms: false
      };
    };

    $scope.getBusiness = function () {
      Business.show({ id: $rootScope.current_business }, function (result) {
        $scope.biz = result;
        $rootScope.initializeBusiness(result);
      });
    };
    $scope.getBusiness();
    Businesses.set_google_auth_paths({}, function (response) {
      $scope.analytics_auth_path = response.analytics_auth_path;
      $scope.search_console_auth_path = response.search_console_auth_path;
    });

    $scope.disconnectAccount = function(service) {
      Business.adwords_disconnect({}, { type: service }, function(response) {
        toastr.success(
          service + ' account disconnected successfully',
          'Success!'
        );
        $scope.getBusiness();
      });
    };

    $scope.updateBusiness = function(params) {
      Business.update_business({ id: $scope.biz.id }, params, function(
        response
      ) {
        toastr.success('Account disconnected successfully', 'Success!');
        $scope.getBusiness();
        $scope.biz = response.business;
      });
      return $scope.biz;
    };

    $scope.CallRailModal = function(type) {
      if (type == 'disconnect') {
        var params = {};
        params['callrail_id'] = '';
        params['callrail_account_id'] = '';
        params['callrail_company_id'] = '';
        $scope.updateBusiness(params);
        $scope.updateIntegrationDetails('callrail_name');
      } else {
        $mdDialog
          .show({
            scope: Utility.closeModal($scope, $mdDialog),
            controller: 'CallRailIntegrationController',
            templateUrl: 'themeX/integrations/_callrail_integration.html'
          })
          .then(function() {})
          .finally(function() {
            $scope.getBusiness();
          });
      }
    };

    $scope.updateIntegrationDetails = function(key) {
      var details = _.omit($rootScope.details, key);
      var params = {
        details: details
      };
      ThirdPartyIntegrationService.update(
        {
          business_id: $rootScope.current_business
        },
        params,
        function(response) {
          $rootScope.details = response.details;
        },
        Utility.logError
      );
    };

    $scope.openAdWordsAccountsModal = function(service) {
      $mdDialog
        .show({
          controller: 'AdwordsClientController',
          templateUrl: 'themeX/integrations/_adwords_setup.html',
          locals: {
            service: service,
            business: $scope.biz
          }
        })
        .then(function() {})
        .finally($scope.getBusiness);
    };

    $scope.openIntegrationModal = function(e) {
      $mdDialog
        .show({
          controller: 'IntergrationController',
          templateUrl: 'themeX/integrations/_integration_scripts.html'
        })
        .then(function() {})
        .finally($scope.getBusiness);
    };

    $scope.openCampaignsModal = function(service) {
      $mdDialog
        .show({
          scope: Utility.closeModal($scope, $mdDialog),
          controller: 'AdwordsCampaignsController',
          templateUrl: 'themeX/integrations/_campaign_selection.html',
          locals: {
            service: service,
            business: $scope.biz,
            changeClient: $scope.openAdWordsAccountsModal
          }
        })
        .then(function() {})
        .finally($scope.getBusiness);
    };

    $scope.openFbLeadGenFormModal = function(e) {
      $mdDialog
        .show({
          scope: Utility.closeModal($scope, $mdDialog),
          controller: 'FbLeadgenFormController',
          templateUrl: 'themeX/integrations/_fb_leadgen_form_scripts.html'
        })
        .then(function() {})
        .finally($scope.getBusiness);
    };

    $scope.openFacebookAdsModal = function(e) {
      $mdDialog
        .show({
          scope: Utility.closeModal($scope, $mdDialog),
          controller: 'FacebookAdsIntegration',
          templateUrl: 'themeX/integrations/_facebook_ads_scripts.html'
        })
        .then(function() {})
        .finally($scope.getBusiness);
    };

    $scope.openFacebookCampaignsModal = function(e) {
      $mdDialog
        .show({
          scope: Utility.closeModal($scope, $mdDialog),
          controller: 'FacebookAdsIntegration',
          templateUrl: 'themeX/integrations/_facebook_campaigns_scripts.html'
        })
        .then(function() {})
        .finally($scope.getBusiness);
    };

    $scope.confirmDisconnect = function (integration) {
      var confirm = $mdDialog
        .confirm()
        .title('Delete this Integration!')
        .textContent('Are you sure?')
        .ok('Yes')
        .cancel('Cancel');

      $mdDialog
        .show(confirm)
        .then(function () {
          $scope.disconnectAccount(integration);
        })
        .finally(function () {
          $scope.updateIntegrationDetails('adwords_' + integration);
        });
    };

    $timeout(function () {
      try {
        if ($rootScope.previousRouteObject.params.service)
          $scope.openCampaignsModal(
            $rootScope.previousRouteObject.params.service
          );
      } catch (error) {}
    }, 2000);
    /* end woofoo section */

    $scope.setFilter = function (filter_value) {
      $scope.setDisplaySectionsFalse();
      $scope.filter[filter_value] = true;
    };

    $scope.disconnectGoogleSearchConsole = function () {
      Business.disconnect_google_search_console(
        { id: $scope.biz.id },
        function (response) {
          $scope.biz = response.business;
          toastr.success('Google Search Console Disconnected Successfully');
        }
      );
    };

    $scope.disconnectGoogleAnalytics = function () {
      Business.disconnect_google_analytics(
        { id: $scope.biz.id },
        function (response) {
          $scope.biz = response.business;
          toastr.success('Google Analytics Disconnected Successfully');
        }
      );
    };

    $scope.integrationDetails = function() {
      Business.integration_details(
        {
          id: current_business
        },
        function(result) {
          $rootScope.details = result.details || {};
        },
        function(error) {
          console.log('Failed to fetch the account details');
        }
      );
    };

    $scope.integrationDetails();

    $timeout(function() {
      var offset = Math.floor($('#sticky-offset').offset().top);

      if ($window.innerWidth >= 768) {
        $('#integration-menu').stick_in_parent({
          offset_top: offset,
          recalc_every: 1
        });
      }

      angular.element($window).bind('resize', function() {
        if ($window.innerWidth < 768) {
          $('#integration-menu').trigger('sticky_kit:detach');
        } else {
          $('#integration-menu').stick_in_parent({
            offset_top: offset,
            recalc_every: 1
          });
        }
        $scope.$digest();
      });
    });

    $scope.closeModal = function() {
      $mdDialog.cancel();
    };
  }
]);
