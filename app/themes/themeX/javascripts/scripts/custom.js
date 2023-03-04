/*! jquery.cookie v1.4.1 | MIT */
!function(a){"function"==typeof define&&define.amd?define(["jquery"],a):"object"==typeof exports?a(require("jquery")):a(jQuery)}(function(a){function b(a){return h.raw?a:encodeURIComponent(a)}function c(a){return h.raw?a:decodeURIComponent(a)}function d(a){return b(h.json?JSON.stringify(a):String(a))}function e(a){0===a.indexOf('"')&&(a=a.slice(1,-1).replace(/\\"/g,'"').replace(/\\\\/g,"\\"));try{return a=decodeURIComponent(a.replace(g," ")),h.json?JSON.parse(a):a}catch(b){}}function f(b,c){var d=h.raw?b:e(b);return a.isFunction(c)?c(d):d}var g=/\+/g,h=a.cookie=function(e,g,i){if(void 0!==g&&!a.isFunction(g)){if(i=a.extend({},h.defaults,i),"number"==typeof i.expires){var j=i.expires,k=i.expires=new Date;k.setTime(+k+864e5*j)}return document.cookie=[b(e),"=",d(g),i.expires?"; expires="+i.expires.toUTCString():"",i.path?"; path="+i.path:"",i.domain?"; domain="+i.domain:"",i.secure?"; secure":""].join("")}for(var l=e?void 0:{},m=document.cookie?document.cookie.split("; "):[],n=0,o=m.length;o>n;n++){var p=m[n].split("="),q=c(p.shift()),r=p.join("=");if(e&&e===q){l=f(r,g);break}e||void 0===(r=f(r))||(l[q]=r)}return l};h.defaults={},a.removeCookie=function(b,c){return void 0===a.cookie(b)?!1:(a.cookie(b,"",a.extend({},c,{expires:-1})),!a.cookie(b))}});
    
$(function() {
  // prettyPrint();      //Apply Code Prettifier

  $('.refresh-panel').click(function() {
    var panel = $(this).closest('.panel');
    panel.append(
      '<div class="panel-loading"><div class="panel-loader-circular"></div></div>'
    );
    setTimeout(function() {
      panel.find('.panel-loading').remove();
    }, 1500);
  });

  // Bootstrap JS
  $('.popovers').popover({
    container: 'body',
    trigger: 'hover',
    placement: 'top'
  }); //bootstrap's popover
  $('.tooltips, [data-toggle="tooltip"]').tooltip(); //bootstrap's tooltip

  $('.select').dropdown(); // DropdownJS

  //Tabdrop
  jQuery.expr[':'].noparents = function(a, i, m) {
    return jQuery(a).parents(m[3]).length < 1;
  }; // Only apply .tabdrop() whose parents are not (.tab-right or tab-left)
  $('.nav-tabs')
    .filter(':noparents(.tab-right, .tab-left)')
    .tabdrop();

  //Background Pattern
  $('.demo-blocks').click(function() {
    $('.layout-boxed').css('background', $(this).css('background'));
    return false;
  });

  $('#daterangepicker2').daterangepicker(
    {
      ranges: {
        Today: [moment(), moment()],
        Yesterday: [moment().subtract('days', 1), moment().subtract('days', 1)],
        'Last 7 Days': [moment().subtract('days', 6), moment()],
        'Last 30 Days': [moment().subtract('days', 29), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [
          moment()
            .subtract('month', 1)
            .startOf('month'),
          moment()
            .subtract('month', 1)
            .endOf('month')
        ]
      },
      opens: 'left',
      startDate: moment().subtract('days', 29),
      endDate: moment()
    },
    function(start, end) {
      $('#daterangepicker2 span').html(
        start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')
      );
    }
  );

  $('#locabusinessbours').click(function() {
    this.checked ? $('#locabusicon').show(500) : $('#locabusicon').hide(500);
  });
});
function darkMode() {
  if ($.cookie('darkModeEnabled') != "true") {
    $('body').removeClass('dark-mode-on');
  } else {
    $('body').addClass('dark-mode-on');
  }
}
$(document).ready(function() {
  darkMode();
});
$(document).on('click', '.toggle-darkmode', function() {
  if($('body').hasClass('dark-mode-on')) {
    $.cookie('darkModeEnabled', "false");
  } else {
    $.cookie('darkModeEnabled', "true");
  };
  darkMode();
});
// $(function() {
//   if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
//     $('body').addClass('dark-mode-on');
//   }
// })
// window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
//   const newColorScheme = event.matches ? "dark" : "light";
//   if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
//     $('body').addClass('dark-mode-on');
//   } else {
//     $('body').removeClass('dark-mode-on');
//   }
// });
