//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.ui.touch-punch.min

//= require tooltip
//= require popover
//= require cloudinary

//= require moment
//= require bootstrap-datetimepicker




//= require angularX

//= require angular.cloudinary
//= require angular-file-upload.min
//= require angular-file-upload-shim.min

//=# require angular-ui-router.min
//= require angular-wizard.min
//= require inflection.min
//= require ngInflection.min
//= require underscore-min
//= require underscore.string.min
//= require smart-table.min
//= require ng-infinite-scroll.min
//= require angular-sanitize
//= require angular.audio
//= require ngStorage.min
//= require menu-script
//= require papaparse.min
//= require angular-cookies
//= require isteven-omni-bar
//= require tek.progress-bar.min
//= require ng-sortable.min
//= require ng-csv.min
//= require select.min
//= require jquery.inputmask.bundle.js
//=# require jquery.slimscroll.min
//=# require angular-ui-bootstrap
//= require angular-rails-templates

//= require pluginX.js


//= require highcharts
//= require highcharts-more
//= require highmap-plugin
//= require highmap-world
//= require worldmap
//= require exporting
//= require solid-gauge

//=# require highmap-data
//=# require highmap-exporting




// slimscroll
//= require jquery.slimscroll.min
//= require angular-slimscroll

//= require jqcloud.min.js
//= require angular-jqcloud.js


//= require angular-payments



//= require angular/themeX_app
//= require_tree ../../../assets/javascripts/angular/
//= require_tree ../../../assets/javascripts/templates/
//= require_tree ../../../assets/javascripts/themeX_routes/
//= require_tree ../../../assets/javascripts/angular/directives/
//= require_tree ../../../assets/javascripts/themeX_directives/
//= require_tree ../../../assets/javascripts/themeX_helpers/

//= require scriptX.js




//= require mapIndex
//= require combobox
//= require loading-bar
//= require redactor-rails
//= require angular-redactor
//= require jquery-rater

//= require angular-aside.min
//= require ng-file-upload-all.min
//= require ng-file-upload-shim.min

//= require clipboard.min
//= require ngclipboard.min
//= require ngAutocomplete
//= require jquery.urlive.min
//= require sortable
//= require grid/masonry.pkgd.min
//= require grid/imagesloaded.pkgd.min
//= require grid/angular-masonry.min

function assign_keys(cloud, preset) {

  $.cloudinary.config().cloud_name = cloud;
  $.cloudinary.config().upload_preset = preset;

  if((/localhost|dev|0.0.0.0/).test(document.location.href)){
    $.cloudinary.config().cloud_name = 'htro6l1zt';
    $.cloudinary.config().upload_preset = 'image_upload';
  }
}
