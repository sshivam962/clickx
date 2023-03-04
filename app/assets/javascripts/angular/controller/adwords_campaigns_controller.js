clickxApp.controller('AdwordsCampaignsController', [
  '$scope',
  'Businesses',
  'service',
  'business',
  'changeClient',
  '$rootScope',
  'orderByFilter',
  '$mdDialog',
  function(
    $scope,
    Businesses,
    service,
    business,
    changeClient,
    $rootScope,
    orderBy,
    $mdDialog
  ) {
    $scope.service = service;
    var current_service = service + '_campaign_ids';
    $scope.business = business;
    var client_id = service + '_client_id';
    var update_for = 'save_' + current_service;
    $scope.selected_data = [];
    $scope.available_data = [];
    $scope.showSpinner = true;
    $scope.warningText = 'No campaigns available!';
    $scope.error_text_present = false
    $scope.allSelected = false;
    var select_campaign_type = 'automate_' + service +'_campaign'
    $scope.automated = $scope.business[select_campaign_type]

    $scope.service_names = {'adword': 'Search' }

    function checkAllSelected() {
      $scope.allSelected = _.every($scope.available_data, function(campaign) {
        return campaign['selected'];
      });
    }

    function toggleCampaign(index) {
      if ($scope.available_data[index]['selected'])
        $scope.available_data[index]['selected'] = false;
      else $scope.available_data[index]['selected'] = true;
      checkAllSelected();
    }

    function toggleAllCampaigns(value) {
      $scope.available_data = _.map($scope.available_data, function(campaign) {
        campaign['selected'] = value;
        return campaign;
      });
      $scope.allSelected = value;
    }

    $scope.selectCampaign = function(index) {
      toggleCampaign(index);
    };

    $scope.selectAll = function() {
      toggleAllCampaigns(true);
    };

    $scope.deselectAll = function() {
      toggleAllCampaigns(false);
    };

    $scope.fetchAdwordCampaigns = function() {
      $scope.showSpinner = true
      Businesses.adword_campaigns(
        {
          client_id: $scope.business[client_id],
          type: service
        },
        function(response) {
          $scope.showSpinner = false;
          if (response.status == 200) {
            $scope.available_data = orderBy(response.data, 'name', false);
            $scope.available_data = _($scope.available_data).map(function(
              campaign
            ) {
              _($scope.business[current_service]).each(function(id) {
                if (campaign.id == id) campaign['selected'] = true;
              });
              return campaign;
            });
            checkAllSelected();
          } else if (response.status == 400) {
            $scope.warningText = response.error;
            $scope.error_text_present = true
          }
        },
        Utility.logError
      );
    }

    if($scope.automated){
      $scope.showSpinner = false;
    } else{
      $scope.fetchAdwordCampaigns()
    }

    $scope.saveCampaignIds = function() {
      adword_campaign_ids = _(
        _.filter($scope.available_data, function(campaign) {
          return campaign['selected'];
        })
      ).pluck('id');

      params = { automated: $scope.automated };
      params['id'] = $scope.business.id;
      params[current_service] = adword_campaign_ids;
      Businesses[update_for](
        params,
        function(response) {
          if (response.status == 200) {
            $rootScope.initializeBusiness(response.business);
            $mdDialog.cancel();
            toastr.success(response.message);
          } else {
            toastr.error(response.message);
          }
        },
        Utility.logError
      );
    };

    var changeAdWordClient = changeClient;

    $scope.changeClient = function() {
      changeAdWordClient($scope.service);
    };
  }
]);
