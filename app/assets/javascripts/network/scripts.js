jQuery(document).on('click', '.toggle-nav', function() {
  if(jQuery('body').hasClass('nav-visible')) {
    jQuery('body').removeClass('nav-visible');
  } else {
    jQuery('body').addClass('nav-visible');
  }
});
$(document).ready(function(){
  $(document).on('click', '.toggle-dropdown', function() {
    if($(this).parent('li').hasClass('submenu-visible')) {
      $(this).parent('li').removeClass('submenu-visible');
    } else {
      $(this).parent('li').addClass('submenu-visible');
    }
  });
  $(document).on('click', '.header-nav-bg', function() {
    $('body').removeClass('nav-visible');
  });
});
$(document).on("click", function(event){
  if(!$(event.target).closest(".dropdown").length){
    $(".menu-dropdown").parent('li').removeClass('submenu-visible');
  }
});

// Overlay
$(document).on('click', '.overlay-show', function(e) {
  e.preventDefault();
  var targetId = $(this).attr('data');
  $('#'+targetId).fadeIn();
})
$(document).on('click', '.overlay-close', function(e) {
  e.preventDefault();
  $('.overlay').fadeOut();
});
$(document).on('click', '.btn--slide-toggle', function(e) {
  e.preventDefault();
  var targetId = $(this).attr('data');
  if($('#'+targetId).is(':visible')) {
    $('#'+targetId).slideUp();
  } else {
    $('#'+targetId).slideDown();
  }
});

var beamer_config = {
  product_id : 'ibsHgiWh40902', //'MozlTJIr39739',
  selector : '.show-beamer-notifications',
};
jQuery(document).on('click', '.slide-toggle-btn', function() {
  if(jQuery('.slide-toggle').is(':visible')) {
    jQuery('.slide-toggle').slideUp();
  } else {
    jQuery('.slide-toggle').slideDown();
  }
});

var winWIdth = $(window).width();
if(winWIdth > 1023) {
  if($('.project-deatils-wrapper').length) {
    var sidebar = new StickySidebar('.project-deatils-col', {
      topSpacing: 20,
      bottomSpacing: 20,
      containerSelector: '.main-content',
      innerWrapperSelector: '.project-deatils-wrapper'
    });
  }
} else {
  $(document).on('click', '.btn-back--project-details', function() {
    $('.project-deatils-wrapper').fadeOut();
  });
  $(document).on('click', '.project-card', function() {
    $('.project-deatils-wrapper').fadeIn();
  })
};

$("input[data='currency']").on({
  keyup: function() {
    formatCurrency($(this));
  },
  blur: function() {
    formatCurrency($(this), "blur");
  }
});

// Format currency
function formatNumber(n) {
  return n.replace(/\D/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",")
}
function formatCurrency(input, blur) {
  var input_val = input.val();
  if (input_val === "") { return; }
  var original_len = input_val.length;
  var caret_pos = input.prop("selectionStart");
  if (input_val.indexOf(".") >= 0) {
    var decimal_pos = input_val.indexOf(".");
    var left_side = input_val.substring(0, decimal_pos);
    var right_side = input_val.substring(decimal_pos);
    left_side = formatNumber(left_side);
    right_side = formatNumber(right_side);
    if (blur === "blur") {
      right_side += "00";
    }

    right_side = right_side.substring(0, 2);

    input_val = "$" + left_side + "." + right_side;

  } else {
    input_val = formatNumber(input_val);
    input_val = "$" + input_val;

    if (blur === "blur") {
      input_val += ".00";
    }
  }

  input.val(input_val);

  var updated_len = input_val.length;
  caret_pos = updated_len - original_len + caret_pos;
  input[0].setSelectionRange(caret_pos, caret_pos);
}

$(document).ready(function(){
  $('.auto-height').autoheight();
});
$(window).resize(function(){
  $('.auto-height').autoheight();
});
