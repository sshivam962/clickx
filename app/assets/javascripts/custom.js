$(document).ready(function() {
  $('.close').bind('click', function(e) {
    $(this).parent().remove();
    e.preventDefault();
  });
});

window.setTimeout(function() { $(".alert-dismissible").remove(); }, 3000);
