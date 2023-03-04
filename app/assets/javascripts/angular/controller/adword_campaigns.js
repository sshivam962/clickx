clickxApp.controller('AdwordCampaigns', [
  '$scope',
  '$rootScope',
  'Businesses',
  '$location',
  function (
    $scope,
    $rootScope,
    Businesses
  ) {
    $rootScope.current_controller = 'home';
    $scope.ad_tab = 'campaigns';
    $scope.rows_per_page = 25;

    $scope.fetchAdwordCampaigns = function () {
      Businesses.adword_campaigns({}, function (response) {
        if (response.status == 200) {
          $scope.campaigns = response.data;
          $scope.copy_campaigns = $scope.campaigns;
        } else if (response.status == 400) {
          $scope.warningText = response.error;
          $scope.error_text_present = true;
        }
      });
    };

    $scope.fetchAdwordCampaigns();

    $scope.showLocations = function (campaign) {
      Businesses.campaign_locations(
        { campaign_id: campaign.id },
        function (response) {
          $scope.location_title = 'Locations for ' + campaign.name;
          if (response.status == 200) {
            $scope.locations = response.data;
            $scope.locations = _.sortBy($scope.locations, 'is_negative');
            $scope.copy_locations = $scope.locations;
          } else if (response.status == 400) {
            $scope.warningText = response.error;
            $scope.error_text_present = true;
          }
        }
      );
    };
  }
]);
