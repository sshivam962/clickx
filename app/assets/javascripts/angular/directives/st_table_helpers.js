/**
 * Created by sibin on 29/12/16.
 */
clickxApp.directive('triggerStTableAfterEvents', [
  function() {
    return {
      require: '^stTable',
      restrict: 'A',
      link: function(scope, element, attr, stTable) {
        scope.$on('triggerSTTable', function() {
          stTable.pipe(stTable.tableState());
        });
      }
    };
  }
]);
