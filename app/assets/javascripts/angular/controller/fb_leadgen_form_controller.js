clickxApp.controller('FbLeadgenFormController', [
  '$scope',
  'FbAds',
  'Business',
  '$rootScope',
  '$mdDialog',
  'FbLeads',
  '$timeout',
  'ThirdPartyIntegrationService',
  function(
    $scope,
    FbAds,
    Business,
    $rootScope,
    $mdDialog,
    FbLeads,
    $timeout,
    ThirdPartyIntegrationService
  ) {
    $scope.pages = [];
    $scope.is_loading = true;

    FbLeads.pages(
      {
        business_id: $rootScope.current_business
      },
      function(response) {
        updateAccountDetails(response.account_name, 'facebook_account');
        if (response.data.length > 0) {
          $scope.handleAccountList(response.data);
        } else {
          $scope.is_loading = true;
          $scope.error = 'There are no pages found in this account.';
        }
      },
      function(error) {
        $scope.is_loading = true;
        $scope.error = error.data.error;
      }
    );

    $scope.handleAccountList = function(response) {
      $scope.pages = response
      $scope.is_loading = false;
      FbLeads.subscribed_pages(
        {
          business_id: $rootScope.current_business
        },
        function(response) {
          if (response.data.length > 0) {
            _.each(response.data, function(page) {
              $scope.updateSelectedPageStatus(page);
            });
          }
        },
        function(error) {
          $scope.is_loading = true;
          $scope.error = error.data.error;
        }
      );

    };

    $scope.updateSelectedPageStatus = function(page_id) {
      selected_page = _.find($scope.pages, function(page) {
        return page.id == page_id;
      });
      if (selected_page){
        FB.api(
          '/' + selected_page.id + '/subscribed_apps',
          'get',
          {
            access_token: selected_page.access_token
          },
          function(response) {
            $timeout(function() {
              var app = response.data;
              if (app.length > 0 && app[0].id == fb_app_id) {
                selected_page.is_selected = true;
              } else {
                selected_page.is_selected = false;
              }
            }, 100);
            $scope.is_loading = false;
          }
        );
      }
    };

    $scope.switchSelection = function(page) {
      if (page.is_selected) {
        unSubscribeApp(page.id);
      } else {
        subscribeApp(page.id);
      }
    };

    var subscribeApp = function(page_id) {
      var leadgen_params = {};
      leadgen_params.page_id = page_id;
      FbLeads.subscribe(
        {
          business_id: $rootScope.current_business
        },
        leadgen_params,
        function(response) {
          toastr.success('Page successfully subscribed.', 'Success');
          setSelection(page_id);
        },
        function(error) {
          if(error.data.base[0].includes('OAuthException')){
            toastr.error('Subscribing to the page failed due to an authentication error, please reconnect your account', 'Error');
          }else{
            toastr.error('Subscribing to the page failed', 'Error');
          }
          console.log(error.data.base[0])
          $scope.isConnected = true;
        }
      );
    };

    var unSubscribeApp = function(page_id) {
      FbLeads.unsubscribe(
        {
          business_id: $rootScope.current_business,
          page_id: page_id
        },
        function(response) {
          toastr.success('Page successfully unsubscribed.', 'Success');
          setSelection(page_id);
        },
        function(error) {
          toastr.error(error, 'Error');
        }
      );
    };

    var setSelection = function(id) {
      $scope.pages = _.each($scope.pages, function(item) {
        if (item.id == id) {
          item.is_selected = !item.is_selected;
        }
      });
    };

    var deleteIntegrationDetails = function(key) {
      var details = _.omit($rootScope.details, key);
      var params = {
        details: details
      };
      setIntegrationDetails(params);
    };

    var updateAccountDetails = function(info, name) {
      var params = {
        details: $rootScope.details
      };
      params['details'][name] = info;
      setIntegrationDetails(params);
    };

    var setIntegrationDetails = function(params) {
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
