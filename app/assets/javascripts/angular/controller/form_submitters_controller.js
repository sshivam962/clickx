clickxApp.controller('FormSubmittersController', [
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
      params['offset'] = pagination.start || 0;
      params['limit'] = pagination.number || 10;
      $scope.rows_per_page = pagination.number;
      EmbeddableService.submitters(params, function(response) {
        console.log(response);
        $scope.contacts = $scope.safe_contacts = response.contacts;
        var totalSize = response.total_contact || 0;
        console.log(pagination.number, pagination.start, totalSize);
        tableState.pagination['to'] = Math.min(
          pagination.start + pagination.number,
          totalSize
        );
        $scope.paginationStart = pagination.start || 0;
        tableState.pagination.total_pages = totalSize;
        tableState.pagination.numberOfPages = Math.ceil(
          totalSize / params.limit
        );
        // console.log(tableState);
      });
    };

    $scope.getters = {
      fullname: function(value) {
        //this will sort by the length of the first name string
        return value.fname + ' ' + value.lname;
      }
    };
  }
]);
