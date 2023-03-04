$(document).ready(function() {
  $('a#authy-request-sms-link').unbind('ajax:success');
  $('a#authy-request-sms-link').bind('ajax:success', function(evt, data, status, xhr) {
    $(".session_alert").append(
      "<div class='notice alert alert-warning fade in'>" +
        "<a class='close' data-dismiss='alert'>x</a>" +
        "<p><strong>" +
          data.message +
        "</strong></p>" +
      "</div>"
    );
  });

  $('a#authy-request-phone-call-link').unbind('ajax:success');
  $('a#authy-request-phone-call-link').bind('ajax:success', function(evt, data, status, xhr) {
    $(".session_alert").append(
      "<div class='notice alert alert-warning fade in'>" +
        "<a class='close' data-dismiss='alert'>x</a>" +
        "<p><strong>" +
          data.message +
        "</strong></p>" +
      "</div>"
    );
  });
});

