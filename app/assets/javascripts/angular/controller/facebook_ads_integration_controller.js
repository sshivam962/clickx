clickxApp.controller('FacebookAdsIntegration', [
  '$scope',
  '$rootScope',
  'FbAds',
  '$mdDialog',
  'ThirdPartyIntegrationService',
  function ($scope, $rootScope, FbAds, $mdDialog, ThirdPartyIntegrationService) {
    $scope.is_loading = true;
    $scope.ad_accounts = [];
    $scope.error = '';
    $scope.saved_account_name = '';
    $scope.ad_account_id = '';
    $scope.showSpinner = true;
    $scope.fb_account_campaigns = [];
    $scope.all_campaigns = [];

    FbAds.fb_account_campaigns(
      {
        id: $scope.current_business
      },
      function(result) {
        $scope.fb_account_campaigns = result.account_campaigns;
      }
    );

    function checkAllSelected() {
      $scope.allSelected = _.every($scope.all_campaigns, function(campaign) {
        return campaign['selected'];
      });
    }

    function toggleAllCampaigns(value) {
      $scope.all_campaigns = _.map($scope.all_campaigns, function(campaign) {
        campaign['selected'] = value;
        return campaign;
      });
      $scope.allSelected = value;
    }

    $scope.selectAll = function() {
      toggleAllCampaigns(true);
    };

    $scope.deselectAll = function() {
      toggleAllCampaigns(false);
    };

    function get_all_campaigns() {
      FbAds.fb_all_campaigns(
        {
          id: $rootScope.current_business
        },
        function (response) {
          $scope.showSpinner = false;
          $scope.all_campaigns = response.data.campaigns
          $scope.all_campaigns = _($scope.all_campaigns).map(function(
            campaign
          ) {
            _($scope.fb_account_campaigns).each(function(id) {
              if (campaign.id == id) campaign['selected'] = true;
            });
            return campaign;
          });
        },
        function (error) {
        }
      );
    }
    get_all_campaigns();

    $scope.pickThisCampaign = function (campaign, index) {
      FbAds.create_campaign(
        {
          id: $rootScope.current_business,
          campaign: campaign
        },
        function (result) {
          toastr.success('Ad campaign updated successfully');
          // $scope.ad_account_id = ad_account.id;
          // $scope.ad_accounts.reduce(filterSelectedAccount, $scope.ad_accounts);
        },
        function (error) {
          toastr.error('Error in linking ad account');
        }
      );
    };

    FbAds.fb_ad_accounts(
      {
        id: $rootScope.current_business
      },
      function (response) {
        if (response.ad_account && response.ad_account.account_id)
          $scope.ad_account_id = response.ad_account['account_id']
        getIntegrationDetails(response.data);
        updateAccountDetails(response.account_name, 'facebook_account');
      },
      function (error) {
        $scope.error = error.data.error;
      }
    );

    $scope.pickThisAccount = function (ad_account) {
      ad_account.is_selected = true;
      FbAds.create_account(
        {
          id: $rootScope.current_business,
          ad_account: ad_account
        },
        function (result) {
          toastr.success('Ad account linked successfully');
          $scope.ad_account_id = ad_account.id;
          $scope.ad_accounts.reduce(filterSelectedAccount, $scope.ad_accounts);
        },
        function (error) {
          toastr.error('Error in linking ad account');
        }
      );
    };

    $scope.disconnectAccount = function () {
      FbAds.destroy(
        {
          id: $rootScope.current_business
        },
        function (response) {
          $mdDialog.cancel();
          deleteIntegrationDetails('facebook_account');
        },
        function (error) {
          toastr.error(error.error, 'Error');
        }
      );
    };

    var deleteIntegrationDetails = function (key) {
      var details = _.omit($rootScope.details, key);
      var params = {
        details: details
      };
      setIntegrationDetails(params);
    };

    var updateAccountDetails = function (info, name) {
      var params = {
        details: $rootScope.details
      };
      params['details'][name] = info;
      setIntegrationDetails(params);
    };

    var filterSelectedAccount = function (accounts, account) {
      account.id === $scope.ad_account_id
        ? (account.is_selected = true)
        : (account.is_selected = false);
      return accounts;
    };

    var setIntegrationDetails = function (params) {
      ThirdPartyIntegrationService.update(
        {
          business_id: $rootScope.current_business
        },
        params,
        function (response) {
          $rootScope.details = response.details;
        },
        Utility.logError
      );
    };

    var getIntegrationDetails = function (ad_accounts) {
      ThirdPartyIntegrationService.query(
        { business_id: $rootScope.current_business },
        function (response) {
          if (response.details && response.details['facebook_account']) {
            $scope.saved_account_name = response.details['facebook_account'];
            ad_accounts.reduce(filterSelectedAccount, ad_accounts);
          }
          $scope.ad_accounts = ad_accounts;
          $scope.is_loading = false;
        },
        Utility.logError
      );
    };
  }
]);
