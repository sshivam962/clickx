clickxApp.controller('AdwordsController', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  'Businesses',
  '$location',
  '$routeParams',
  '$mdDialog',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    Businesses,
    $location,
    $routeParams,
    $mdDialog
  ) {
    /*********select and drop list variables***********/
    $scope.selectFaIndex = 0;
    $scope.SelectedAvailItems = [];
    $scope.SelectedSelectedListItems = [];
    $scope.SelectedListItems = [[]];
    $scope.AvailableListItems = [[]];
    $scope.selectFaIndex = $scope.FaName = '0';
    $scope.selected_adword_data = [];
    $scope.available_adword_data = [];
    /*********select and drop list variables***********/

    $scope.closeModal = function() {
      $mdDialog.cancel();
    };

    Business.get({ id: $routeParams.business_id }, function(response) {
      $scope.biz = response;
      Businesses.adword_campaigns(
        { client_id: $scope.biz.adword_client_id },
        function(response) {
          if (response.status == 200) {
            $scope.adword_campaigns = response.data;

            /*********for select and drop list***********/
            $.each($scope.adword_campaigns, function(i, object) {
              $.each($scope.biz.adword_campaign_ids, function(i, id) {
                if (object.id == id) {
                  $scope.selected_adword_data.push(object);
                }
              });
            });

            var i = 0;
            $.grep($scope.adword_campaigns, function(el) {
              if ($.inArray(el, $scope.selected_adword_data) == -1) {
                $scope.available_adword_data.push(el);
              }
              i++;
            });

            $scope.DefaultListItems = [$scope.available_adword_data];
            $scope.SelectedListItems = [$scope.selected_adword_data];
            angular.copy($scope.DefaultListItems, $scope.AvailableListItems);
            /*********for select and drop list***********/
          } else if (response.status == 400) {
            toastr.remove();
            toastr.error(response.error, 'Error');
          }
        },
        function(error) {}
      );
    });

    $scope.SaveAdwordsCampaignIds = function() {
      adword_campaign_ids = [];
      $.each($scope.SelectedListItems[0], function(i, v) {
        adword_campaign_ids.push(v.id);
      });
      Businesses.save_adword_campaign_ids(
        { id: $scope.biz.id, adword_campaign_ids: adword_campaign_ids },
        function(response) {
          if (response.status == 200) {
            toastr.success(response.message);
          } else {
            toastr.error(response.message);
          }
        }
      );
    };

    /************ methods of select and drop list START*****************/

    $scope.OnAvailableChange = function() {
      $scope.AvailLength = $scope.SelectedAvailItems.length;
    };

    $scope.btnRight = function() {
      angular.forEach(
        $scope.SelectedAvailItems,
        function(value, key) {
          this.push(value);
        },
        $scope.SelectedListItems[$scope.selectFaIndex]
      );

      angular.forEach($scope.SelectedAvailItems, function(value, key) {
        for (
          var i = $scope.AvailableListItems[$scope.selectFaIndex].length - 1;
          i >= 0;
          i--
        ) {
          if (
            $scope.AvailableListItems[$scope.selectFaIndex][i].name ==
            value.name
          ) {
            $scope.AvailableListItems[$scope.selectFaIndex].splice(i, 1);
          }
        }
      });
      $scope.SelectedAvailItems = [];
    };

    $scope.btnAllRight = function() {
      angular.forEach(
        $scope.AvailableListItems[$scope.selectFaIndex],
        function(value, key) {
          this.push(value);
        },
        $scope.SelectedListItems[$scope.selectFaIndex]
      );

      for (
        var i = $scope.AvailableListItems[$scope.selectFaIndex].length - 1;
        i >= 0;
        i--
      ) {
        $scope.AvailableListItems[$scope.selectFaIndex].splice(i, 1);
      }
    };

    $scope.btnLeft = function() {
      angular.forEach(
        $scope.SelectedSelectedListItems,
        function(value, key) {
          this.push(value);
        },
        $scope.AvailableListItems[$scope.selectFaIndex]
      );

      angular.forEach($scope.SelectedSelectedListItems, function(value, key) {
        for (
          var i = $scope.SelectedListItems[$scope.selectFaIndex].length - 1;
          i >= 0;
          i--
        ) {
          if (
            $scope.SelectedListItems[$scope.selectFaIndex][i].name == value.name
          ) {
            $scope.SelectedListItems[$scope.selectFaIndex].splice(i, 1);
          }
        }
      });
      $scope.SelectedSelectedListItems = [];
    };

    $scope.btnAllLeft = function() {
      angular.forEach(
        $scope.SelectedListItems[$scope.selectFaIndex],
        function(value, key) {
          this.push(value);
        },
        $scope.AvailableListItems[$scope.selectFaIndex]
      );

      for (
        var i = $scope.SelectedListItems[$scope.selectFaIndex].length - 1;
        i >= 0;
        i--
      ) {
        $scope.SelectedListItems[$scope.selectFaIndex].splice(i, 1);
      }
      $scope.SelectedSelectedListItems = [];
    };

    /************ methods of select and drop list END*****************/
  }
]);
