$(document).ready(function() {

  $(document).on('click', '.addon_plans',function() {
    var addon_key = $(this).attr('id');
    if(addon_key == 'template_landing_page_v2_addon')
    {
      if($('.pure-material-checkbox #template_landing_page_v2_addon').is(':checked'))
        $(".pure-material-checkbox #ala_carte_landing_page_hosting_service").prop("checked", true);
      else
        $(".pure-material-checkbox #ala_carte_landing_page_hosting_service").prop("checked", false);
    }
  });

  setTimeout(function(){
    
    $(".addon_auto_check").prop("checked", true).change();
  },1000);
  
  
  $(document).on('click', '.ensure_checklist_cls',function() {
    if($('.ensure_checklist_cls:checked').length == $('.ensure_checklist_cls').length)
    {
      $(".addon_auto_check").prop("checked", false).change();
    }
    else
    {
      $(".addon_auto_check").prop("checked", true).change();
    }
  });
  
  $(document).on('click', '.step_complete',function() {
    next_step = $(this).data('next-step')
    current_step = $(this).data('current-step')
    if(current_step == 'client'){
      selected_business = $('#selected_business').val()
      if(selected_business == 'add_business' || selected_business == 'add_from_leads'){
        $('.checkout_create_client_submit').click()
      }else if(selected_business == ''){
        toastr.error("Please Select client")
      }else {
        $('#business_id').val(selected_business)
        $('.checkout_steps').addClass('hidden')
        $('#step_' + next_step + '_content').removeClass('hidden')
      }
    }else if(current_step == 'payment'){
      selected_card = $('#selected_card').val()
      if(selected_card == 'add_card'){
        $('.checkout_create_card_submit').click()
      }else if(selected_card == ''){
        toastr.error("Please Select card")
      }else{
        $('#card_id').val(selected_card)
        $('#new_package_subscription_form').submit()
      }
    }else if(current_step == 'agreement'){
      $('.agreement_submit').click()
    }else {
      if($('#funnel_platform_required').val() ==  'true'){
        checked = $('input[name="funnel_platform_check"]:checked').val();
        if (checked == undefined) {
          toastr.error("Please Choose a Funnel Platform")
        }else{
          $('.checkout_steps').addClass('hidden')
          $('#step_' + next_step + '_content').removeClass('hidden')
        }
      }else{
        $('.checkout_steps').addClass('hidden')
        $('#step_' + next_step + '_content').removeClass('hidden')
      }
    }
  })

  $('#selected_card').on('change', function (e) {
    var optionSelected = $("option:selected", this);
    var valueSelected = this.value;
    if(valueSelected == 'add_card'){
      $.ajax({
        url: $('#base_route').val() + "/new_card",
        type: 'get',
        data: {},
        dataType: 'json',
        success:function(response){
          $('#add_card_form').html(response.data)
        }
      })
    }else{
      $('#add_card_form').html('')
    }
  });

  $('#selected_business').on('change', function (e) {
    var optionSelected = $("option:selected", this);
    var valueSelected = this.value;
    $('.lead_selection').addClass('hidden')
    $('#selected_lead').val('')
    if(valueSelected == 'add_business'){
      $.ajax({
        url: $('#base_route').val() + "/new_business",
        type: 'get',
        data: {},
        dataType: 'json',
        success:function(response){
          $('.add_business_form').html(response.data)
        }
      })
    }else if(valueSelected == 'add_from_leads') {
      $('.lead_selection').removeClass('hidden')
    }
  });

  $(document).on('change', '#selected_lead',function() {
    var optionSelected = $("option:selected", this);
    var valueSelected = this.value;
    $.ajax({
      url: $('#base_route').val() + "/new_business?lead_id=" + valueSelected,
      type: 'get',
      data: {},
      dataType: 'json',
      success:function(response){
        $('.add_business_form').html(response.data)
      }
    })
  });

  $(document).on('change', '.payment_checks',function() {
    amount = parseFloat($('#plan_amount').val(), 10);
    quantity = parseFloat($('#quantity').val()) || 1;
    amount *= quantity
    eo_val = $('#expedited_onboarding_fees').val();
    ct_val = $('#call_tracking_amount').val();
    gs_val = $('#g_suite_amount').val();
    ld_val = $('#logo_design_amount').val();
    onetime_charge = $('#onetime_charge').val();
    if($('#expedited_onboarding').is(":checked") && $.isNumeric(eo_val)){
      eo_fees = parseFloat(eo_val, 10)
    }else{
      eo_fees = 0
    }
    if($('#addons_call_tracking').is(":checked") && $.isNumeric(ct_val)){
      ct_fees = parseFloat(ct_val, 10)
    }else{
      ct_fees = 0
    }
    if($('#addons_g_suite').is(":checked") && $.isNumeric(gs_val)){
      gs_fees = parseFloat(gs_val, 10)
    }else{
      gs_fees = 0
    }
    if($('#addons_logo_design').is(":checked") && $.isNumeric(ld_val)){
      ld_fees = parseFloat(ld_val, 10)
    }else{
      ld_fees = 0
    }
    if($.isNumeric(onetime_charge)){
      oc_fees = parseFloat(onetime_charge, 10)
    }else{
      oc_fees = 0
    }
    addon_amount = 0
    $('.addon_plans:checkbox:checked').each(function() {
      addon_amount = addon_amount + parseFloat($(this).data('amount'))
    });
    total = amount + eo_fees + ct_fees + gs_fees + oc_fees + ld_fees + addon_amount
    $(".total_amount_due").text('$' + parseFloat(total, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString());
  });

  $(document).on('change', '#white_glove_service',function() {
    package_category = $('#package_category').val()
    if(package_category != 'bundle'){
      addon_ids = $.map($('.addon_plans:checked'), function(c){return c.value; })
      $.ajax({
        url: $('#base_route').val() + '/change_plan',
        type: 'post',
        data: {
          expedited_onboarding: $('#expedited_onboarding').is(":checked"),
          white_glove_service: $('#white_glove_service').is(":checked"),
          plan: $("#plan").val(),
          package: $("#package").val(),
          addons: addon_ids
        },
        dataType: 'json',
        success:function(response){
          $('#plan_details').html(response.data.content)
          $('#new_package_subscription_form').attr('action', response.data.form_action);
        }
      })
    }
  });

  $(document).on('change', 'input[type=radio][name=change_plan]',function() {
    addon_ids = $.map($('.addon_plans:checked'), function(c){return c.value; })
    $.ajax({
      url: $('#base_route').val() + '/load_plan',
      type: 'post',
      data: {
        expedited_onboarding: $('#expedited_onboarding').is(":checked"),
        white_glove_service: $('#white_glove_service').is(":checked"),
        plan: $("#plan").val(),
        package: $("#package").val(),
        addons: addon_ids,
        quantity: (parseFloat($('#quantity').val()) || 1),
        new_plan: $("input[name='change_plan']:checked").val()
      },
      dataType: 'json',
      success:function(response){
        $('#plan_details').html(response.data.content)
        $('#new_package_subscription_form').attr('action', response.data.form_action);
      }
    })
  });
});
