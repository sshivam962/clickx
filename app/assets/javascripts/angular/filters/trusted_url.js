clickxApp.filter('trusted_url', [
  '$sce',
  function($sce) {
    return function(url) {
      return $sce.trustAsResourceUrl(url);
    };
  }
]);

clickxApp.filter('get_full_website', function() {
  return function(input) {
    var httpCheck = /^http|https/;
    if (input != '' && httpCheck.test(input)) {
      return input;
    } else {
      return 'http://' + input;
    }
  };
});
