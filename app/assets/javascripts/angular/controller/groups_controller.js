// clickxApp.controller('GroupsList', ['$scope', '$rootScope', '$http', '$resource', 'Groups',
//   'Question', 'QuestionOrder','$location',  function($scope, $rootScope, $http, $resource, Groups,
//     Question, QuestionOrder, $location) {

//    $scope.groups = Groups.query();
//    $rootScope.current_controller = 'groups';
//    $scope.deleteGroup = function (groupId) {
//     toastr.options = {
//       "closeButton": true
//     };
//     toastr.error('Are you sure?<br /><button class="btn delete" style="background-color:white;color:red;font-weight:bolder;padding: 2px 4px;width: 50px;">Yes</button>', 'Delete this Group');
//     $('.delete').click(function(){
//         $scope.deleteThisGroup(groupId);
//     });
//     toastr.options = {
//       "closeButton": false
//     };
//    }
//    $scope.deleteThisGroup = function (groupId) {
//      Group.delete({ id: groupId }, function(){
//        $scope.groups = Groups.query();
//        $rootScope.flash = {};
//        $rootScope.flash.message = "Group Deleted Successfully";
//        $location.path('/groups');
//      });
//    };
// }]);
