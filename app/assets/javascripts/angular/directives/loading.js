clickxApp.directive('loading', [
  function() {
    return {
      restrict: 'E',
      replace: true,
      template:
        '<div class="well"><p class="text-center">' +
        '<i class="fa fa-spinner fa-spin"></i>' +
        'Loading... <br> Please Wait. </p></div>'
    };
  }
]);
