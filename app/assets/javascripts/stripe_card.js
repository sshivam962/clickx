'use strict';
$(function() {
  var stripe = Stripe($('#stripe_publishable_key').val());
  $.fn.stripeCard = function(){
    var elements = stripe.elements({
      // Stripe's examples are localized to specific languages, but if
      // you wish to have Elements automatically detect your user's locale,
      // use `locale: 'auto'` instead.
      locale: window.__exampleLocale
    });

    // Floating labels
    var inputs = document.querySelectorAll('#card-container1 .input');
    Array.prototype.forEach.call(inputs, function(input) {
      input.addEventListener('focus', function() {
        input.classList.add('focused');
      });
      input.addEventListener('blur', function() {
        input.classList.remove('focused');
      });
      input.addEventListener('keyup', function() {
        if (input.value.length === 0) {
          input.classList.add('empty');
        } else {
          input.classList.remove('empty');
        }
      });
    });

    var elementStyles = {
      base: {
        color: '#32325D',
        fontWeight: 500,
        fontFamily: 'Source Code Pro, Consolas, Menlo, monospace',
        fontSize: '16px',
        fontSmoothing: 'antialiased',

        '::placeholder': {
          color: '#CFD7DF',
        },
        ':-webkit-autofill': {
          color: '#e39f48',
        },
      },
      invalid: {
        color: '#E25950',

        '::placeholder': {
          color: '#FFCCA5',
        },
      },
    };

    var elementClasses = {
      focus: 'focused',
      empty: 'empty',
      invalid: 'invalid',
    };

    var cardNumber = elements.create('cardNumber', {
      showIcon: true,
      style: elementStyles,
      classes: elementClasses,
    });
    cardNumber.mount('#card-number-div');

    var cardExpiry = elements.create('cardExpiry', {
      style: elementStyles,
      classes: elementClasses,
    });
    cardExpiry.mount('#card-expiry-div');

    var cardCvc = elements.create('cardCvc', {
      style: elementStyles,
      classes: elementClasses,
    });
    cardCvc.mount('#card-cvc-div');

    registerElements([cardNumber, cardExpiry, cardCvc]);
  };

  function registerElements(elements) {
    var form = document.querySelector('#checkout_create_card');
    var error = form.querySelector('.error');
    var errorMessage = error.querySelector('.card-message');

    function enableInputs() {
      Array.prototype.forEach.call(
        form.querySelectorAll(
          "input[type='text'], input[type='email'], input[type='tel']"
        ),
        function(input) {
          input.removeAttribute('disabled');
        }
      );
    }

    function disableInputs() {
      Array.prototype.forEach.call(
        form.querySelectorAll(
          "input[type='text'], input[type='email'], input[type='tel']"
        ),
        function(input) {
          input.setAttribute('disabled', 'true');
        }
      );
    }

    function triggerBrowserValidation() {
      // The only way to trigger HTML5 form validation UI is to fake a user submit
      // event.
      var submit = document.createElement('input');
      submit.type = 'submit';
      submit.style.display = 'none';
      form.appendChild(submit);
      submit.click();
      submit.remove();
    }

    // Listen for errors from each Element, and show error messages in the UI.
    var savedErrors = {};
    elements.forEach(function(element, idx) {
      element.on('change', function(event) {
        if (event.error) {
          error.classList.add('visible');
          savedErrors[idx] = event.error.message;
          errorMessage.innerText = event.error.message;
        } else {
          savedErrors[idx] = null;

          // Loop over the saved errors and find the first one, if any.
          var nextError = Object.keys(savedErrors)
            .sort()
            .reduce(function(maybeFoundError, key) {
              return maybeFoundError || savedErrors[key];
            }, null);

          if (nextError) {
            // Now that they've fixed the current error, show another one.
            errorMessage.innerText = nextError;
          } else {
            // The user fixed the last error; no more errors.
            error.classList.remove('visible');
          }
        }
      });
    });

    // Listen on the form's 'submit' handler...
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      // Trigger HTML5 validation UI on the form if any of the inputs fail
      // validation.
      var plainInputsValid = true;
      Array.prototype.forEach.call(form.querySelectorAll('input'), function(
        input
      ) {
        if (input.checkValidity && !input.checkValidity()) {
          plainInputsValid = false;
          return;
        }
      });
      if (!plainInputsValid) {
        triggerBrowserValidation();
        return;
      }

      // Disable all inputs.
      disableInputs();

      // Gather additional customer data we may have collected in our form.
      if($('#current_page').val() == 'signup'){
        var name = $('#billing_first_name').val() + ' ' + $('#billing_last_name').val()
        var address1 = $('#billing_address_line1').val();
        var address2 = $('#billing_address_line2').val();
        var country = $('#country_select').val();
        var state = $('#state_select').val();
        var city = $('#billing_address_city').val();
        var zip = $('#billing_address_zip').val();
      }else if ($('#current_page').val() == 'payment_link') {
        var name = '';
        var address1 = '';
        var address2 = '';
        var country = '';
        var state = '';
        var city = '';
        var zip = '';
      }else{
        var name = $('#card_name').val();
        var address1 = $('#card_address_line1').val();
        var address2 = $('#card_address_line2').val();
        var country = $('#country_select').val();
        var state = $('#state_select').val();
        var city = $('#card_address_city').val();
        var zip = $('#card_address_zip').val();
      }
      var additionalData = {
        name: name,
        address_line1: address1,
        address_line2: address2,
        address_country: country,
        address_state: state,
        address_city: city,
        address_zip: zip
      };

      // Use Stripe.js to create a token. We only need to pass in one Element
      // from the Element group in order to create a token. We can also pass
      // in the additional customer data we collected in our form.
      stripe.createToken(elements[0], additionalData).then(function(result) {
        if (result.token) {
          if($('#current_page').val() == 'signup'){
            $('#card_token').val(result.token.id);
            $('#signup_form').submit();
          }else if ($('#current_page').val() == 'payment_link') {
            $('#card_token').val(result.token.id);
            $('#payment_link_subscribe_form').submit();
          }else{
            if($('#proposal_id').length != 0) {
              var proposal_id = $('#proposal_id').val();
            }
            else {
              var proposal_id = '';
            };
            $.ajax({
              url: $('#base_route').val() + "/create_card",
              type: 'post',
              data: {
                token: result.token.id,
                card: { name: name },
                proposal_id: proposal_id
              },
              dataType: 'script',
              success:function(response){
              }
            })
          }
        } else {
          // Otherwise, un-disable inputs.
          enableInputs();
          if ($('#current_page').val() == 'payment_link') {
            $.rails.enableElement($('.card_submit_button'))
            $.rails.enableElement($('.checkout_create_card_submit'))
            $('input.checkout_create_card_submit').removeAttr('disabled')
          }
        }
      });
    });
  }
});
