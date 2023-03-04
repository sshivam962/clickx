// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/widget
//= require jquery-ui/sortable
//= require ./custom
//= require bootstrap-sprockets
//= require devise_authy
//= require jquery_nested_form
//= require cocoon

$(document).ready(function() {
  /* off-canvas sidebar toggle */
  resizeDiv();
  /** Sidebar toggle on Profile pages ( layout: base) **/
  /** When use mouse in / mouse out **/
  winWIdth = $(window).width();
  if(winWIdth > 991) {
    $("#sidebar").mouseenter(function() {
      $(this).find("ul#xs-menu").hide();
      $(this).find("ul#lg-menu").show();

      $(this).addClass("openedSidebar").css({
        width: "275px"
      });
    });
    $("#sidebar").mouseleave(function() {
      $(this).find("ul#xs-menu").show();
      $(this).find("ul#lg-menu").hide();

      $(this).removeClass("openedSidebar").css({
        width: "91px"
      });
    });
  }

  /** eof sidebar toggle **/

  $(document).on('click', '.hamburger', function() {
    if($(this).hasClass('active')) {
      $('.hamburger').removeClass('active');
      $('body').removeClass('nav-visible');
    } else {
      $('.hamburger').addClass('active');
      $('body').addClass('nav-visible');
    }
  });
  $(document).on('click', '.bg-sidebar-overlay', function() {
    $('.hamburger').removeClass('active');
    $('body').removeClass('nav-visible');
  });
});

window.onresize = function(event) {
  resizeDiv();
};

function resizeDiv() {
  var wh = $(window).height();
  $(".container > .wrap").css({ "min-height": wh + "px" });
}
