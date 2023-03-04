/**
 * Created by sibin on 23/8/16.
 */
var placeSearch = {};
$(document).ready(function(){
  if($('#business_target_city').length > 0){
    placeSearch = new google.maps.places.Autocomplete(
      (document.getElementById('business_target_city')),
      {types:["geocode"]}
    )
  }
})
