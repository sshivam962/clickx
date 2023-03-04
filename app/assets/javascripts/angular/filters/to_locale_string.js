clickxApp.filter('toLocaleString', function() {
  return function(number) {
    if (number || number == 0) return parseInt(number).toLocaleString();
    return;
  };
});
