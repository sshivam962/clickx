var CountrySelect = (function () {
  return {
    changeStateAccordingToCountry: function () {
      $('#country_select').change(function () {
        CountrySelect.fetchStates();
      });

      if ($('#country_select').val()) {
        CountrySelect.fetchStates();
      }
    },

    fetchStates: function () {
      var url = $('#country_select').data('url');
      var partial = $('#country_select').data('partial');
      var field_name = $('#country_select').data('field-name');

      $.ajax({
        url: url,
        type: 'get',
        data: {
          country: $('#country_select').val(),
          partial: partial,
          field_name: field_name,
        },
        dataType: 'json',
        success: function (resp) {
          $('#state_div').html(resp.content);
        },
      });
    },
  };
})();

$(function () {
  CountrySelect.changeStateAccordingToCountry();
});
