clickxApp.directive('popoverReadability', function() {
  return {
    restrict: 'E',
    replace: true,
    template: function(element, attrs) {
      return (
        '<ul class="padding-zero">' +
        '<li><span><i class="glyphicon glyphicon-time"></i> ' +
        attrs.note +
        '</span></li></ul>'
      );
    }
  };
});
