clickxApp.filter('timeOver', function() {
  return function(time) {
    return moment().isAfter(time);
  };
});
