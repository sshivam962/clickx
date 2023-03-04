clickxApp.controller('contentWritersAccess', [
  '$scope',
  '$rootScope',
  'ContentOrder',
  '$mdDialog',
  '$timeout',
  '$window',
  '$routeParams',
  function(
    $scope,
    $rootScope,
    ContentOrder,
    $mdDialog,
    $timeout,
    $window,
    $routeParams
  ) {
    $scope.business_id = $rootScope.current_business;
    $scope.content_data = [];
    $scope.star_per_value = [];
    $scope.business_cards_list = [];
    var writers_keys = [
      'two_star_writer',
      'three_star_writer',
      'four_star_writer',
      'five_star_writer',
      'six_star_writer'
    ];
    $scope.writers_levels = _.range(4, 7);

    /* Get Form Data */
    ContentOrder.content_order_form_data(function(result) {
      $scope.content_data = result.data;
    });
    $scope.saveForm = function(e) {
      e.preventDefault();
    };

    $scope.price_not_get = true;
    $scope.writersObject = {
      minwords: 300,
      maxwords: 500,
      writer: 5,
      hourstocomplete: 24,
      paidreview: 2
    };

    $scope.default_content_order_data = {};
    /* Get default content order data */
    ContentOrder.content_order_default_show(
      {
        business_id: $scope.business_id
      },
      function(result) {
        if (result.status == 200 && result.data) {
          $scope.default_content_order_data = _.pick(
            result.data,
            'company_information',
            'target_audience',
            'things_to_avoid',
            'things_to_mention'
          );
          $scope.writersObject = _.extend(
            $scope.default_content_order_data,
            $scope.writersObject
          );
        }
      },
      function(error) {}
    );
    /* eof get default content order */
    if ($routeParams.id) {
      $scope.order_id = $routeParams.id;
      ContentOrder.content_order_get(
        {
          id: $routeParams.id
        },
        function(result) {
          if (result.status == 200 && result.data && result.data.form_data) {
            $scope.writersObject = _.extend(
              $scope.writersObject,
              result.data.form_data
            );
          }
        },
        function(error) {}
      );
    }

    $scope.$watch(
      'writersObject',
      function(newValue, oldValue) {
        $scope.price_not_get = true;
        if ($scope.writersObject.minwords >= $scope.writersObject.maxwords) {
          $scope.writersObject.maxwords = $scope.writersObject.minwords + 50;
        }
        /*
       *  writer star value * total words + (total words / 2000) * 14$ + 25%
       */
        if (newValue.writer && $scope.content_data) {
          if ($scope.content_data.length == 0) return false;
          var writer_star_value = (
            $scope.content_data[writers_keys[newValue.writer - 2]] *
            newValue.maxwords
          ).toFixed(2);
          var totalCosts = parseFloat(
            writer_star_value *
              (100 + $scope.content_data.markup_percentage) *
              0.01
          );
          $scope.article_price = totalCosts.toFixed(2);
          if (newValue.paidreview == 2) {
            var proof_reading_cost = (
              (newValue.maxwords / 2000) *
              $scope.content_data['proofreading_cost']
            ).toFixed(2);
            totalCosts =
              totalCosts +
              parseFloat(
                proof_reading_cost *
                  (100 + $scope.content_data.markup_percentage) *
                  0.01
              );
            $scope.proof_reading_price = parseFloat(
              proof_reading_cost *
                (100 + $scope.content_data.markup_percentage) *
                0.01
            ).toFixed(2);
          }
          $scope.total_price = parseFloat(totalCosts).toFixed(2);
          $scope.price_not_get = false;
        }
      },
      true
    );
    $scope.num_completed_days = _.range(1, 21);

    // Save form
    $scope.openPaymentModal = function(event) {
      event.preventDefault();
      /* Open Payment Modal */
      $mdDialog
        .show({
          templateUrl: 'writers_payment_modal.html',
          controller: 'writersPaymentController',
          resolve: {
            local_object: function() {
              //Local variables passed to modal
              var local_object = {
                business_id: $scope.business_id,
                order_status: 1,
                form_data: $scope.writersObject
              };
              if ($routeParams.id) {
                local_object['id'] = $routeParams.id;
              }
              if (
                local_object.form_data &&
                local_object.form_data['paidreview']
              ) {
                local_object.form_data['paidreview'] = parseInt(
                  local_object.form_data['paidreview']
                );
              }
              return local_object;
            }
          }
        })
        .then(
          function(response) {
            if (response) {
              $timeout(function() {
                $rootScope['do_not_save_form'] = true;
                $window.location.href = '/#/contents';
              }, 100);
            }
          },
          function(log) {}
        )
        .finally(function() {});

      /* eof payment modal */
    };

    /**
     * Autosave When route change
     */
    $scope.$on('$routeChangeStart', function(aEvent, next, current) {
      var formToSend = {
        business_id: $scope.business_id,
        order_status: 0,
        form_data: $scope.writersObject
      };
      if ($routeParams.id) {
        formToSend['id'] = $routeParams.id;
      }
      if (
        typeof $rootScope.do_not_save_form == 'undefined' ||
        $rootScope.do_not_save_form == false
      ) {
        //prevent unwanted save after payment
        if ($scope.writersObject.title) {
          // check if title exist
          if ($routeParams.id) {
            ContentOrder.content_order_update(
              { id: $routeParams.id },
              formToSend,
              function(u_result) {
                toastr.success(u_result.message);
              },
              function(u_error) {}
            );
          } else {
            ContentOrder.content_order_create(
              formToSend,
              function(result) {
                toastr.success(result.message);
              },
              function(error) {}
            );
          }
        }
        delete $rootScope.do_not_save_form;
      }
    });
    /** end autosave */

    $scope.saveDraft = function(event) {
      var formToSend = {
        business_id: $scope.business_id,
        order_status: 0,
        form_data: $scope.writersObject
      };

      if ($routeParams.id) {
        formToSend['id'] = $routeParams.id;
      }
      if ($routeParams.id) {
        ContentOrder.content_order_update(
          { id: $routeParams.id },
          formToSend,
          function(u_result) {
            toastr.success(u_result.message);
            $rootScope['do_not_save_form'] = true;
            $window.location.href = '/#/content/view_orders';
          },
          function(u_error) {}
        );
      } else {
        ContentOrder.content_order_create(
          formToSend,
          function(result) {
            toastr.success(result.message);
            $rootScope['do_not_save_form'] = true;
            $window.location.href = '/#/content/view_orders';
          },
          function(error) {}
        );
      }
    };
  }
]);

clickxApp.controller('writersPaymentController', [
  '$scope',
  '$rootScope',
  '$mdDialog',
  'ContentOrder',
  'local_object',
  '$window',
  '$timeout',
  function(
    $scope,
    $rootScope,
    $mdDialog,
    ContentOrder,
    local_object,
    $window,
    $timeout
  ) {
    $scope.cardOject = {};
    $scope.business_cards_list = [];
    ContentOrder.business_cards_list(
      { business_id: local_object.business_id || $rootScope.business_id },
      function(result) {
        if (result.status == 200) {
          $scope.business_cards_list = _.map(result.payment_details, function(
            card,
            index
          ) {
            var card_details = card.card_info.split('_');
            card['type'] = card_details[0].toLowerCase();
            card['number'] = card_details[1];
            return card;
          });

          console.log($scope.business_cards_list);
        }
      }
    );

    /**
     *
     * @param status
     * @param response
     */
    $scope.paymentProcess = function(status, response) {
      if (status == 200) {
        // Save data and redirect to content list
        if (response.id) {
          /* form_data name , stripeEmail , stripeToken, catd_final_digits */
          var formToCreatePayment = local_object;
          formToCreatePayment['name'] = $scope.name;
          formToCreatePayment['stripeEmail'] = $scope.email;
          formToCreatePayment['stripeToken'] = response.id;
          formToCreatePayment['card_final_digits'] =
            response.card.brand + '_XXXX-XXXX-XXXX-' + response.card.last4;
          if (local_object.id) {
            /* For Draft payment */
            ContentOrder.content_order_update(
              { id: local_object.id },
              formToCreatePayment,
              function(result) {
                console.log(result);
                if (result.status == 200 && result.body == 'succeeded') {
                  toastr.success('Payment Successful');
                  toastr.success('Content ordered successfully..');
                  $timeout(function() {
                    $mdDialog.hide('success');
                  }, 200);
                } else if (result.status == 404) {
                  toastr.error(result.body);
                }
              },
              function(error) {
                console.log(error);
              }
            );
          } else {
            /* For new Payment */
            ContentOrder.content_order_create(
              formToCreatePayment,
              function(result) {
                console.log(result);
                if (
                  result.status == 200 &&
                  (result.body == 'succeeded' || result.body == 'paid')
                ) {
                  toastr.success('Payment successfull');
                  $timeout(function() {
                    $mdDialog.hide('success');
                  }, 200);
                } else if (result.status == 404) {
                  toastr.error(result.body);
                }
              },
              function(error) {
                console.log(error);
              }
            );
          }
        }
      } else {
        toastr.error('Payment failed');
        $scope.stripe_form.$setPristine();
        $scope.number = $scope.expiry = $scope.name = $scope.cvc = null;
      }
    };

    /**
     * Send Existing Card details
     * @params existing_card
     *
     */
    $scope.sendExistingCardDetails = function(event, exisitingCard) {
      exisitingCard = _.extend(exisitingCard, local_object);

      if (local_object.id) {
        /// id of draft
        // Payment from draft
        ContentOrder.content_order_update(
          { id: local_object.id },
          _.omit(
            exisitingCard,
            'id',
            'name',
            'email',
            'card_info',
            'created_at',
            'updated_at'
          ),
          function(result) {
            console.log(result);
            if (result.status == 200 && result.body == 'succeeded') {
              toastr.success('Payment Successfull');
              $timeout(function() {
                $mdDialog.hide('success');
              }, 200);
            } else if (result.status == 404) {
              toastr.error(result.body);
            }
          },
          function(error) {
            toastr.error(error.message);
          }
        );
      } else {
        // New Payment
        ContentOrder.content_order_create(
          _.omit(
            exisitingCard,
            'id',
            'name',
            'email',
            'card_info',
            'created_at',
            'updated_at'
          ),
          function(result) {
            console.log(result);
            if (result.status == 200 && result.body == 'succeeded') {
              toastr.success('Payment Successfull');
              $timeout(function() {
                $mdDialog.hide('success');
              }, 200);
            } else if (result.status == 404) {
              toastr.error(result.body);
            }
          },
          function(error) {
            toastr.error(error.message);
          }
        );
      }
    };

    $scope.cancel = function() {
      $mdDialog.cancel('cancel');
    };
  }
]);
