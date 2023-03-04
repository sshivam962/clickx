// Agency Plan Payment
clickxApp.controller('PackageSubscriptions', [
  '$scope',
  '$rootScope',
  '$routeParams',
  '$http',
  '$templateRequest',
  '$compile',
  '$location',
  'Agency',
  '$location',
  function(
    $scope,
    $rootScope,
    $routeParams,
    $http,
    $templateRequest,
    $compile,
    $location,
    Agency,
    $location
  ) {

    $scope.agency_id = $routeParams.agency_id;
    Agency.show({id: $scope.agency_id},
      function(resp) {
        $scope.agency = resp;
      }
    );

    Agency.package_plans({id: $scope.agency_id},
      function(resp) {
        $scope.package_plans = resp.data;
        if($routeParams.category){
          $scope.current_package = resp.data[$routeParams.category][$routeParams.plan]
        }
      }
    );
    $scope.fetch_cards = function(default_card) {
      Agency.fetch_cards({}, function(response) {
        $scope.cards = response.data.cards;
        if (response.data.default_card) {
          $.each($scope.cards, function(i, element) {
            if (element.id == response.data.default_card) {
              $scope.selected_card = element;
              $scope.default_selected_card = element;
            }
          });
        }
        if ($scope.cards.length == 0) {
          $scope.new_card_selected = true;
        }
      });
    };
    $scope.fetch_cards();
    $scope.checkoutPlan = function(category, plan){
      $location.path('/packages/checkout').search({category: category, plan: plan});
    }
    $scope.showAddCardForm = function(selected_card) {
      $scope.new_card = null;
      if (selected_card == 'add_card') {
        $scope.new_card_selected = true; // for preventing 'change payment method' div disappearing
        // $scope.cards = [];
        $scope.selected_card = null;
      } else {
        $scope.selected_card = selected_card;
        $scope.new_card_selected = false;
      }
    };
    $scope.changePaymentMethod = function() {
      $scope.change_payment_method = true;
    };
    $scope.subscribePlan = function(
      new_card,
      selected_card
    ) {
      if (selected_card == null && new_card == null) {
        toastr.error('Please add a Card');
        $scope.change_payment_method = true;
      } else {
        $('.card_submit').prop('disabled', true);
        Agency.subscribe_package(
          {
            card: new_card,
            selected_card: selected_card,
            plan: $routeParams.plan,
            category: $routeParams.category
          },
          function(response) {
            if (response.status == 200) {
              toastr.success('You have successfully subscribed for ' + $scope.current_package['name']);
              $location.path('/dashboard')
            } else {
              $('.card_submit').prop('disabled', false);
              toastr.error(response.message);
              $location.path('/dashboard')
            }
          }
        );
      }
    };
  }
]);
