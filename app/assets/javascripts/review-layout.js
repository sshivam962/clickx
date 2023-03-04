//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require jquery.rateit
//= require clipboard.min

function checkform(){
  if($('#review-rating').val() == '0'){
    alert('Please provide your rating')
    return false;
  }
}

$(document).ready(function(){
  $(function () {
    $('#review-rating-rateit').rateit(
      {
        min: 0,
        max: 5,
        step: 1,
        backingfld: '#review-rating'
      }
    );
  });

  var clipboard = new Clipboard('.clipboard-btn');
})
