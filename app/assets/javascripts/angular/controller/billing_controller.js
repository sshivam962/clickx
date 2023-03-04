clickxApp.controller('BillingInfo', [
  '$scope',
  '$routeParams',
  '$rootScope',
  'Business',
  'Plans',
  '$mdDialog',
  function($scope, $routeParams, $rootScope, Business, Plans, $mdDialog) {
    $scope.current_subscription = {};
    $scope.selected_new_plan = null;
    $scope.client_plans = [];
    $scope.cards = null;
    $scope.new_card = null;
    $scope.selected_card = null;
    $scope.show_selected_card = null;
    $scope.current_plan_card_change = false;

    if ($scope.current_agency_name != 'Clickx') {
      window.location.href = '/b/dashboard';
    }

    $scope.fetch_current_subscription = function() {
      Business.current_plan({}, function(response) {
        $scope.current_subscription = response.data.active;
        $scope.downgraded_subscription = response.data.downgraded;
        $scope.trial_end = response.data.trial_end;
        $scope.free_subscription = response.data.set_as_free;
        $scope.free_start = response.data.free_start;
        $scope.has_costom_plan = response.data.has_costom_plan;
      });
    };

    $scope.fetch_client_plans = function() {
      Plans.client_plans({}, function(response) {
        $scope.client_plans = response.plans;
        $.each($scope.client_plans, function(i, plan) {
          if (plan.metadata.features != undefined) {
            plan['features'] = plan.metadata.features
              .split(',')
              .filter(function(v) {
                return v !== '';
              });
          }
        });
      });
    };

    $scope.fetch_cards = function() {
      Business.fetch_cards({}, function(response) {
        $scope.cards = response.data.cards;
        $scope.cards_copy = angular.copy($scope.cards);
        if (response.data.default_card) {
          $.each($scope.cards, function(i, element) {
            if (element.id == response.data.default_card) {
              $scope.selected_card = element;
              $scope.show_selected_card = element;
            }
          });
        }
      });
    };

    $scope.subscribe = function(new_card, selected_card) {
      $('.card_submit').prop('disabled', true);
      Business.subscribe(
        {
          card: new_card,
          selected_card: selected_card,
          plan: $scope.selected_new_plan
        },
        function(response) {
          if (response.status == 200) {
            $scope.current_subscription = response.data.current_subscription;
            $scope.cards = response.data.cards;
            $scope.selected_card = response.data.default_card;
            $scope.show_selected_card = response.data.default_card;
            $scope.downgraded = response.data.downgraded;
            $scope.downgraded_subscription =
              response.data.downgraded_subscription;
            $scope.trial_end = response.data.trial_end;
            $scope.free_subscription = false;
            $scope.fetch_cards();
            toastr.success('Success');
            $scope.selected_new_plan = null;
            $('.card_submit').prop('disabled', false);
          } else {
            $('.card_submit').prop('disabled', false);
            toastr.error(response.message);
          }
        }
      );
    };

    $scope.updateCard = function(new_card, selected_card) {
      $('.card_submit').prop('disabled', true);
      Business.update_card(
        {
          card: new_card,
          selected_card: selected_card,
          plan: $scope.current_subscription
        },
        function(response) {
          if (response.status == 200) {
            $scope.cards = response.data.cards;
            $scope.selected_card = response.data.default_card;
            $scope.show_selected_card = response.data.default_card;
            $scope.current_plan_card_change = false;
            toastr.success('Card updated successfully');
            $('.card_submit').prop('disabled', false);
          } else {
            $('.card_submit').prop('disabled', false);
            toastr.error(response.message);
          }
        }
      );
    };

    $scope.cancelDowngrade = function() {
      confirm = $mdDialog
        .confirm()
        .textContent('Are you sure you want to perform this action?')
        .ok('Yes')
        .cancel('Cancel');
      $mdDialog.show(confirm).then(
        function() {
          Business.cancel_downgrade({}, function(response) {
            if (response.status == 200) {
              toastr.success(response.message);
              $scope.downgraded_subscription = null;
              $scope.free_subscription = false;
            } else {
              toastr.error(response.message);
            }
          });
        },
        function() {}
      );
    };

    $scope.showAddCardForm = function(selected_card) {
      $scope.cards = $scope.cards_copy;
      if (selected_card == 'add_card') {
        $scope.cards = [];
        $scope.selected_card = null;
      }
    };

    $scope.changeCard = function(toggle) {
      $scope.showAddCardForm();
      $scope.getCurrentPlan();
      $scope.free_plan_selected = false;
      $scope.current_plan_card_change = toggle;
      if (toggle) {
        $scope.selected_new_plan = null;
      }
    };

    $scope.selectFree = function() {
      $scope.free_plan_selected = true;
      $scope.current_plan_card_change = false;
      $scope.selected_new_plan = false;
    };

    $scope.subscribeToFreePlan = function() {
      Business.subscribe_to_free(
        { subscription_id: $scope.current_subscription.account_id },
        function(response) {
          if ((response.status = 200)) {
            $scope.free_subscription = true;
            $scope.free_start = response.data.free_start;
            $scope.downgraded_subscription = false;
            $scope.free_plan_selected = false;
            toastr.success(response.message);
          } else {
            toastr.error(response.message);
          }
        }
      );
    };

    $scope.cardOptions = {
      debug: false,
      formatting: true,
      width: 500
    };

    $scope.fetch_current_subscription();
    $scope.fetch_client_plans();
    $scope.fetch_cards();

    $scope.SetSelectedNewPlan = function(plan) {
      $scope.changeCard(false);
      $scope.selected_new_plan = plan;
    };

    $scope.removeSelectedNewPlan = function() {
      $scope.selected_new_plan = null;
    };

    $scope.removeFreePlan = function() {
      $scope.free_plan_selected = false;
    };

    $scope.getCurrentPlan = function() {
      $.each($scope.client_plans, function(i, plan) {
        if ($scope.current_subscription) {
          if (plan.plan_id == $scope.current_subscription.plan_id) {
            $scope.current_plan = plan;
          }
        }
      });
    };
  }
]);
