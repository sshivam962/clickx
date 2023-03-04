// clickxApp.controller('ReferralAnalytics', [
//   '$scope',
//   '$rootScope',
//   '$http',
//   '$resource',
//   'Referrals',
//   '$location',
//   '$routeParams',
//   function(
//     $scope,
//     $rootScope,
//     $http,
//     $resource,
//     Referrals,
//     $location,
//     $routeParams
//   ) {
//     var params = {};
//     $scope.itemsByPage = 15;
//     $scope.sort_order = {
//       first_name: true,
//       visits: true,
//       signups: true
//     };
//     $scope.sort_by = 'visits';
//     $scope.sortBy = function(sort_parameter) {
//       $scope.sort_by = sort_parameter;
//       $scope.sort_order[$scope.sort_by] = !$scope.sort_order[$scope.sort_by];
//       $scope.stCtrl.pipe($scope.stCtrl.tableState());
//     };
//     $scope.getReferralAnalytics = function(tableState, ctrl) {
//       $scope.stCtrl = ctrl;
//       var currentPage =
//         tableState.pagination.start / tableState.pagination.number;
//       params = {
//         page: currentPage + 1 || 1,
//         sort_by: $scope.sort_by,
//         sort_order: $scope.sort_order[$scope.sort_by]
//       };
//       Referrals.analytics(
//         params,
//         function(response) {
//           $scope.referral_analytics = response.data;
//           tableState.pagination.numberOfPages = response.total_pages;
//         },
//         function(error) {
//           toastr.error('Error fetching analytics!');
//         }
//       );
//     };
//   }
// ]);
