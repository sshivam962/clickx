clickxApp.directive('flash', function() {
  var directive = {};
  directive.restrict = 'E'; /* restrict this directive to elements */

  directive.scope = {
    key: '@',
    message: '@'
  };
  directive.templateUrl = 'home/_flash.html';

  directive.link = function(scope, element, attrs) {
    element.find('.close').bind('click', function() {
      element.remove();
    });
    setTimeout(function() {
      element.remove();
    }, 3000);
  };

  return directive;
});
