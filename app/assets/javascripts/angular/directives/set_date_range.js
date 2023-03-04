clickxApp.directive('setDateRange', [
  '$mdDateRangePicker',
  '$rootScope',
  function($mdDateRangePicker, $rootScope) {
    return {
      template:
        '<md-button class="md-raised md-primary" ng-click="load_datewise_analytics($event)"> {{selectedRange.dateStart | date}} - {{selectedRange.dateEnd | date}}</md-button>',
      link: function(scope, element, attr) {
        scope.load_datewise_analytics = function(e) {
          $mdDateRangePicker
            .show({
              model: $rootScope.selectedRange,
              autoConfirm: true,
              customTemplates: $rootScope.mdCustomTemplates,
              showTemplate: true,
              isDisabledDate: $rootScope.isFutureDate
            })
            .then(function(result) {
              if (result) {
                $rootScope.selectedRange = result;
                $rootScope.date = {
                  startDate: moment(result.dateStart).format('YYYY-MM-DD'),
                  endDate: moment(result.dateEnd).format('YYYY-MM-DD')
                };
              }
            });
        };
      }
    };
  }
]);
