clickxApp.controller('FacebookPages', [
  '$scope',
  '$routeParams',
  'FbAds',
  function($scope, $routeParams, FbAds) {
    $scope.current_business = $routeParams.business_id;
    $scope.pageIcon =
      'https://scontent.xx.fbcdn.net/v/t1.0-1/c15.0.50.50/p50x50/399548_10149999285987789_1102888142_n.png?oh=7b892ace39c927306a9a5e7722b2b3de&oe=5A99736A';
    $scope.ad_tab = 'pages';
    $scope.isLoading = false;
    $scope.isConnected = false;

    FbAds.query(
      {
        id: $scope.businessId
      },
      function(result) {
        $scope.pages = result;
      },
      function(error) {
        $scope.page_error = error.data.data;
      }
    );

    FbAds.fb_account_status(
      {
        id: $scope.businessId
      },
      function(result) {
        $scope.is_FB = result.has_facebook;
      }
    );

    $scope.remove_facebook = function() {
      FbAds.remove_facebook_ads({ id: $scope.current_business }, function(
        response
      ) {
        if (response.status == 200) {
          window.location.reload();
        }
      });
    };

    $scope.myFacebookAdLogin = function() {
      $scope.isLoading = true;
      console.log($scope.isLoading);
      FB.login(function(response) {
        FbAds.fb_ad_accounts({ id: $scope.current_business }, function(result) {
          $scope.ad_accounts = result;
        });
      });
    };

    $scope.getPageDetails = function(page) {
      fbPageDetails(page.id);
    };

    function fbPageDetails(id) {
      FbAds.fb_details({ id: id }, function(result) {
        $scope.details = result;
      });
    }
  }
]);
