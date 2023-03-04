//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.ui.touch-punch.min
//= require tooltip
//= require popover
//angularjs-rails
//= require cloudinary

//= require  highcharts
//= require  highcharts-more
//= require exporting





//= require angular-file-upload-shim.min
//= require angular/angular.min
//= require angular-animate/angular-animate
//= require angular-route/angular-route
//= require angular-resource/angular-resource
//= require angular.cloudinary
//= require angular-file-upload.min

//= require ./angular-ui-router.min
//= require ./angular-wizard.min
//= require ./inflection.min
//= require ./ngInflection.min
//= require ./underscore-min
//= require ./underscore.string.min
//= require ./jquery.minicolors
//= require ./angular-minicolors
//= require ./ui-bootstrap-tpls-0.14.1
//= require ./angular-ui-switch.min
//= require ./smart-table.min
//= require ./ng-infinite-scroll.min
//= require angular-sanitize/angular-sanitize
//= require ./moment.min
//= require ./angular-moment.min
//= require ./angular.audio
//= require ./ngStorage.min
//= require ./menu-script
//= require ./papaparse.min
//= require ./angular-cookies
//= require ./isteven-omni-bar
//= require ./tek.progress-bar.min
//= require ./ng-sortable.min
//= require ./angular-tooltips.min
//= require ./ng-csv.min
//= require ./angular-md5
//= require ./select.min
//= require ./jquery.inputmask.bundle.js
//= require ./jquery.slimscroll.min
//= require ./angular-drag-and-drop-lists.min
//= require angular-ui-bootstrap
//= require angular-ui-bootstrap-tpls
//= require angular-rails-templates
//= require angular-gravatar.min




// slimscroll
//= require jquery.slimscroll.min
//= require angular-slimscroll

//= require ./jqcloud.min.js
//= require ./angular-jqcloud.js


//= require ./angular-payments





//= stub angular/themeX_app
//= require_tree ./angular/
//= require_tree ./templates/
//= require_tree ./angular/directives/

//= require  ./solid-gauge


//= require ./highmap-plugin
//=# require ./highmap-data
//=# require ./highmap-exporting
//= require ./highmap-world

//= require ./mapIndex
//= require ./combobox
//= require ./worldmap
//= require ./custom
//= require ./loading-bar
//= require ./toastr
//= require redactor-rails
//= require ./angular-redactor
//= require ./jquery-rater

//= require ./daterangepicker
//= require ./angular-daterangepicker

//= require ./angular-aside.min
//= require ./ng-file-upload-all.min
//= require ./ng-file-upload-shim.min

//= require ./clipboard.min
//= require ./ngclipboard.min
//= require ./ngAutocomplete
//= require ./xeditable.js
//= require jquery.urlive.min
//= require sortable
//= require signup/bootstrap.min
//= require grid/masonry.pkgd.min
//= require grid/imagesloaded.pkgd.min
//= require grid/angular-masonry.min
//= require ng-tags-input/build/ng-tags-input

function assign_keys(cloud, preset) {

  $.cloudinary.config().cloud_name = cloud;
  $.cloudinary.config().upload_preset = preset;
}

// if ('serviceWorker' in navigator) {
//   console.log('Service Worker is supported');
//   navigator.serviceWorker.register('/serviceworker.js')
//     .then(function(registration) {
//       console.log('Successfully registered!', ':^)', registration);
//       registration.pushManager.subscribe({
//         userVisibleOnly: true,
//         applicationServerKey: window.vapidPublicKey
//       })
//         .then(function(subscription) {
//             console.log('endpoint:', subscription.endpoint);
//             $.post("/webpush_subscriptions", { subscription: subscription.toJSON() });
//             console.log(subscription.toJSON());
//         });
//   }).catch(function(error) {
//     console.log('Registration failed', ':^(', error);
//   });
// }
