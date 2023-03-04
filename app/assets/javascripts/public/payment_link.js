//= require jquery
//= require jquery_ujs
//= require plugins/toastr

$(document).ready(function() {
  $(document).on('click', '.pl_next_step',function() {
    next_step = $(this).data('next')
    current_step = $(this).data('current')
    if(current_step == 'plan'){
      if($('#t_and_c_check').length > 0){
        if($('#t_and_c_check').is(':checked')){
          $('#step_li_' + current_step).removeClass('current')
          $('#step_li_' + current_step).addClass('completed')
          $('#step_li_' + next_step).addClass('current')
          $('#step_content_' + current_step).addClass('hidden')
          $('#step_content_' + next_step).removeClass('hidden')
        }else{
          toastr.error('Agree Terms and Conditions.');
        }
      }else{
        $('#step_li_' + current_step).removeClass('current')
        $('#step_li_' + current_step).addClass('completed')
        $('#step_li_' + next_step).addClass('current')
        $('#step_content_' + current_step).addClass('hidden')
        $('#step_content_' + next_step).removeClass('hidden')
      }

    }else if(current_step == 'card'){
      $('.checkout_create_card_submit').click()
    }
  })
  $(document).on('click', '.pl_previous_step',function() {
    previous_step = $(this).data('previous')
    current_step = $(this).data('current')
    if(current_step == 'card'){
      $('#step_li_' + current_step).removeClass('current')
      $('#step_li_' + previous_step).removeClass('completed')
      $('#step_li_' + previous_step).addClass('current')
      $('#step_content_' + current_step).addClass('hidden')
      $('#step_content_' + previous_step).removeClass('hidden')
    }
  })
});
