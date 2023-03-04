clickxApp.directive('uploadFiles', function() {
  return {
    scope: true, //create a new scope
    link: function(scope, el, attrs) {
      el.bind('change', function(event) {
        var files = event.target.files[0];
        scope.$emit('seletedFile', { file: files });
      });
    }
  };
});
