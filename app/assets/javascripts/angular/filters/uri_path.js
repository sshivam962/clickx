clickxApp.filter('urlPath', function() {
  return function(uri) {
    if (uri) {
      return new URL(uri).pathname;
    }
  };
});
