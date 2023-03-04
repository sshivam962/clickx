/**
 * LEAD MAGNET 4 PUBLISH DIRECTIVES
 */

/* Plain Text link */
clickxApp.directive('leadMagnetPlainTextLink', [
  function() {
    return {
      restrict: 'EA',
      replace: true,
      template:
        "<a class='l-m-p-l' href=\"javascript:void(0)\" ng-style='settings.text_button.style' ng-bind='settings.text_button.text'" +
        " ng-show='!!settings.text_button.text' data-lead-magnet-id='settings.tracker.id'></a>",
      link: function(scope, element, attr) {}
    };
  }
]);

/* Button link */
clickxApp.directive('leadMagnetButtonLink', [
  function() {
    return {
      restrict: 'EA',
      replace: true,
      template:
        "<a class='l-m-p-b' href='javascript:void(0)' ng-style='settings.plain_button.style'>{{settings.plain_button.text}}</a>",
      link: function(scope, element, attr) {}
    };
  }
]);

/* Image link */
clickxApp.directive('leadMagnetImageLink', [
  function() {
    return {
      restrict: 'EA',
      replace: true,
      template:
        "<a href='javascript:void(0)'>" +
        "<img ng-src='{{settings.image_button.src}}' alt='settings.image_button.text' class='img-responsive lm-image-box' ng-style='settings.image_button.style'/>" +
        '</a>',
      link: function(scope, element, attr) {}
    };
  }
]);

/* Lead Magnet Content link */
clickxApp.directive('leadMagnetContentLink', [
  function() {
    return {
      restrict: 'AE',
      replace: true,
      template:
        "<div class='clx-l-m-c-b clearfix' ng-class=\"{'inline-flex': settings.bar_button.image.style.float == 'left' || settings.bar_button.image.style.float == 'right'}\" ng-style='settings.bar_button.box.style'>" +
        "<div ng-if=\"settings.bar_button.image.style.float == 'left' || settings.bar_button.image.style.float == 'top'\" ng-class=\"{'content-middle': settings.bar_button.image.style.float == 'top'}\">" +
        "<img ng-if= 'settings.bar_button.image.src' ng-style=\"{'width':settings.bar_button.image.style.width}\" ng-src='{{settings.bar_button.image.src}}' class='img-responsive'/></div>" +
        "<div class='width100' ng-bind-html='settings.bar_button.text.content' ng-style='settings.bar_button.text.style'></div>" +
        "<div ng-if=\"settings.bar_button.image.style.float == 'right' || settings.bar_button.image.style.float == 'bottom'\" ng-class=\"{'content-middle': settings.bar_button.image.style.float == 'bottom'}\">" +
        "<img ng-if= 'settings.bar_button.image.src' ng-style=\"{'width':settings.bar_button.image.style.width}\" ng-src='{{settings.bar_button.image.src}}' class='img-responsive'/></div>" +
        '<style>.clx-l-m-c-t h1,.clx-l-m-c-t h2,.clx-l-m-c-t h3,.clx-l-m-c-t h4,.clx-l-m-c-t h5,.clx-l-m-c-t pre { color: {{settings.bar_button.text.style.color}}} ' +
        '.clx-l-m-c-t p a, .clx-l-m-c-t h1 a, .clx-l-m-c-t h2 a, .clx-l-m-c-t h3 a, .clx-l-m-c-t h4 a, .clx-l-m-c-t h5 a, .clx-l-m-c-t h6 a { color: #15c ; } </style>' +
        '</div>',
      link: function(scope, element, attr) {}
    };
  }
]);
