clickxApp.controller('UserInvite', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  'Users',
  '$location',
  '$routeParams',
  'Businesses',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    Users,
    $location,
    $routeParams,
    Businesses
  ) {
    $rootScope.current_controller = 'businesses';
    $scope.user = { email: '', first_name: '', last_name: '' };
    $scope.user.ownable_type = 'Business';
    $scope.user.ownable_id = $routeParams.id;
    var fields = {
      email: 'Email ',
      role: 'Role ',
      first_name: 'First Name ',
      last_name: 'Last Name '
    };

    function success(response) {
      toastr.success('Successfully Invited User', 'Success');
      if ($rootScope.current_role == 'admin') {
        $rootScope.opened_business_id = $routeParams.id;
        $location.path('/businesses');
      } else {
        // $location.path('/dashboard');
        window.location.href = '/b/dashboard'
      }
    }

    function failure(response) {
      var error_message = '';
      _.each(response.data.errors, function(errors, key) {
        error_message += fields[key] + _.first(errors) + '<br/>';
      });
      toastr.error(error_message, 'Error');
      $('#invite_new_user').prop('disabled', false);
    }

    $scope.invite_user = function(user) {
      Users.invite({ user: user }, success, failure);
    };
  }
]);

clickxApp.controller('ManageUser', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  'Users',
  '$location',
  '$routeParams',
  'Businesses',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    Users,
    $location,
    $routeParams,
    Businesses,
    Users,
    User
  ) {
    $scope.businesses = Businesses.query();
    $scope.selected_business = '';

    $scope.get_non_associated_users = function() {
      $scope.users = Users.get_non_associated_users({
        business_id: $scope.selected_business
      });
    };

    $scope.associate_users = function() {
      $scope.users = Users.get_non_associated_users({
        business_id: $scope.selected_business
      });
    };
  }
]);

clickxApp.controller('ManageBizUsers', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  '$location',
  '$routeParams',
  '$route',
  'Business',
  'User',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    $location,
    $routeParams,
    $route,
    Business,
    User
  ) {
    $rootScope.current_controller = 'users';
    $scope.biz_users = [];
    $scope.copy_biz_users = [];

    $scope.biz = Business.business_users({ id: current_business }, function(
      response
    ) {
      _.each(response, function(user) {
        if (!user.preview_user) {
          $scope.biz_users.push(user);
          $scope.copy_biz_users.push(user);
        }
      });
    });
    $scope.resend_invitation = function(user) {
      User.resend_invitation({ id: user.id }, function() {
        user.invitation_sent_at = new Date().toISOString();
        toastr.success('Invitation sent successfully.', 'Success!');
      });
    };
    $scope.deleteUser = function(userId) {
      toastr.options = {
        closeButton: true
      };
      toastr.error(
        'Are you sure?<br /><button class="btn delete" style="background-color:white;color:red;font-weight:bolder;padding: 2px 4px;width: 50px;">Yes</button>',
        'Delete this User'
      );
      $('.delete').click(function() {
        $scope.deleteThisUser(userId);
      });
      toastr.options = {
        closeButton: false
      };
    };
    $scope.deleteThisUser = function(userId) {
      User.delete({ id: userId }, function() {
        users = $scope.biz_users;
        $scope.biz_users = _.reject(users, function(usr) {
          return usr.id == userId;
        });
        toastr.success('User deleted successfully.', 'Success!');
      });
    };
  }
]);
