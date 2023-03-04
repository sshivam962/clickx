var MailCountrySelect = (function () {
  return {
    changeMailStateAccordingToCountry: function () {
      $('#mail_country_select').change(function () {
        MailCountrySelect.fetchMailStates();
      });

      if ($('#mail_country_select').val()) {
        MailCountrySelect.fetchMailStates();
      }
    },

    fetchMailStates: function () {
      var url = $('#mail_country_select').data('url');
      var partial = $('#mail_country_select').data('partial');
      var field_name = $('#mail_country_select').data('field-name');

      $.ajax({
        url: url,
        type: 'get',
        data: {
          country: $('#mail_country_select').val(),
          partial: partial,
          field_name: field_name,
        },
        dataType: 'json',
        success: function (resp) {
          $('#mail_state_div').html(resp.content);
        },
      });
    },
  };
})();

$(function () {
  MailCountrySelect.changeMailStateAccordingToCountry();
});
