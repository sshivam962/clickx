// clickxApp.controller('RewardReferrals', [
//   '$scope',
//   '$rootScope',
//   '$http',
//   '$resource',
//   'Referrals',
//   '$location',
//   '$routeParams',
//   '$uibModal',
//   function(
//     $scope,
//     $rootScope,
//     $http,
//     $resource,
//     Referrals,
//     $location,
//     $routeParams,
//     $uibModal
//   ) {
//     $rootScope.current_controller = 'business_reward_referrals';
//     var params = {};
//     $scope.itemsByPage = 10;
//     $scope.sort_order = {
//       referree: true,
//       referrer: true
//     };
//     $scope.sort_by = 'referree';
//     $scope.sortBy = function(sort_parameter) {
//       $scope.sort_by = sort_parameter;
//       $scope.sort_order[$scope.sort_by] = !$scope.sort_order[$scope.sort_by];
//       $scope.stCtrl.pipe($scope.stCtrl.tableState());
//     };
//     $scope.getReferredSignups = function(tableState, ctrl) {
//       $scope.stCtrl = ctrl;
//       var currentPage =
//         tableState.pagination.start / tableState.pagination.number;
//       params = {
//         page: currentPage + 1 || 1,
//         sort_by: $scope.sort_by,
//         sort_order: $scope.sort_order[$scope.sort_by]
//       };
//       Referrals.query(
//         params,
//         function(response) {
//           $scope.referred_signups = response.data;
//           tableState.pagination.numberOfPages = response.total_pages;
//         },
//         function(error) {
//           toastr.error(error.statusText, 'Error');
//         }
//       );
//     };

//     $scope.rewardHim = function(referral, index) {
//       var modalInstance = $uibModal.open({
//         animation: true,
//         templateUrl: 'rewardReferrals.html',
//         size: 'sm',
//         scope: $scope,
//         controller: function($scope) {
//           $scope.referral = referral;
//           $scope.close = function() {
//             modalInstance.dismiss('cancel');
//           };
//           $scope.saveNote = function(note) {
//             $scope.referred_signups[index].notes = note;
//             $scope.referred_signups[index].rewarded = true;
//             $scope.referred_signups[index].eligibility = true;
//             var params = {
//               referral_params: {
//                 notes: note,
//                 rewarded: true,
//                 eligibility: true
//               }
//             };
//             Referrals.update(
//               { id: referral.id },
//               params,
//               function(result) {
//                 toastr.success(
//                   referral.referrer.first_name +
//                     ' ' +
//                     referral.referrer.last_name +
//                     ' has been Rewarded',
//                   'Success'
//                 );
//               },
//               function(error) {
//                 toastr.error(error.statusText, 'Error');
//               }
//             );
//           };
//         }
//       });
//     };
//   }
// ]);
