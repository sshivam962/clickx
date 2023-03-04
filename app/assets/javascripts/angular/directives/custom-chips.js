clickxApp.directive('customChip', function() {
  return {
    restrict: 'A',
    link: function(scope, elem, attrs) {
      var mdChip = elem.parent().parent();
      mdChip.css('background', attrs.customChip);
      mdChip.css('color', 'white');
    }
  };
});
