$(document).ready(function()
{
  $('#user_first_name').on('change, keyup', function(){
    $('#billing_first_name').val($('#user_first_name').val())
  })

  $('#user_last_name').on('change, keyup', function(){
    $('#billing_last_name').val($('#user_last_name').val())
  })
});


/**
 * Custom domain validation check
 */
$(document).ready(function(){
  var newFreeSignUpForm = $('#new_user');
  if(newFreeSignUpForm.length > 0){
    // Custom regex to validate domain
    $.validator.addMethod('regex', function(value, element, regexpr) {
      if(value.length===0){
        return true;
      }
      return regexpr.test(value);
    }, 'Please enter a valid domain')

    newFreeSignUpForm.validate({
      rules: {
        'user[first_name]': 'required',
        'user[email]': {
          required: true,
          email: true,
          remote:{
            url: window.location.origin + '/free-email-validator',
            type: 'POST',
            data: {
              email: function(){
                return $("input[name*='user[email]']").val()
              }
            }
          }
        },
        'business[name]': 'required',
        'business[domain]': {
          regex: /([a-z])([a-z0-9]+\.)*[a-z0-9]+\.[a-z.]+/,
          required: function(element){
            return $(element).val().trim().length > 0;
          }
        }
      },
      messages:{
        'user[email]':{
          required: 'Please provide an Email address',
          email: 'Please enter a valid Email address',
          remote: 'Disposable email addresses are not allowed'
        }
      }
    });
  }
});
