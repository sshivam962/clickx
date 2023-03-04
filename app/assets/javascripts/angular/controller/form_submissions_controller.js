clickxApp.controller('FormSubmissionsController', [
  '$scope',
  '$routeParams',
  'EmbeddableService',
  function($scope, $routeParams, EmbeddableService) {
    var params = {
      id: $routeParams.form_id,
      business_id: $routeParams.business_id
    };
    $scope.rows_per_page = 10;

    $scope.stTableServer = function(tableState) {
      $scope.tableState = tableState;
      var pagination = tableState.pagination;
      params['offset'] = pagination.start || 1;
      params['limit'] = pagination.number || 10;
      $scope.rows_per_page = pagination.number;
      EmbeddableService.submitters(params, function(response) {
        $scope.contacts = $scope.safe_contacts = response.contacts;
        var totalSize = response.total_contacts;
        tableState.pagination['to'] = Math.min(
          pagination.start + pagination.number,
          totalSize
        );
        $scope.paginationStart = pagination.start || 1;
        tableState.pagination.total_pages = totalSize;
        tableState.pagination.numberOfPages = Math.ceil(
          totalSize / params.limit
        );
      });
    };

    $scope.getters = {
      fullname: function(value) {
        return value.fname + ' ' + value.lname;
      }
    };
  }
]);
