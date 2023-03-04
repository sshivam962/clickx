clickxApp.factory('Uploads', function() {
  var Uploads = {};

  Uploads.add_local_profile = function($scope, $upload, $rootScope, Location) {
    $scope.upload = $upload
      .upload({
        url:
          'https://api.cloudinary.com/v1_1/' +
          $.cloudinary.config().cloud_name +
          '/upload',
        file: $scope.location.new_local_profile_list,
        fields: {
          upload_preset: $.cloudinary.config().upload_preset,
          folder: 'local_profiles',
          tags: 'local_profiles',
          context: 'local_profile=' + $scope.location.id
        }
      })
      .progress(function(e) {
        //$('.logo').hide();
        $('.upload_button')
          .attr('disabled', 'disabled')
          .text('Upaloding CSV, please wait...');
        if (!$scope.$$phase) {
          $scope.$apply();
        }
      })
      .success(function(data, status, headers, config) {
        //$rootScope.local_profile_list = data.secure_url;
        $scope.location.local_profile_list = data.secure_url;
        $('.upload_button')
          .attr('disabled', 'disabled')
          .text('File Uploaded. Saving location, please wait...');
        if (!$scope.$$phase) {
          $scope.$apply();
        }
        Location.update(
          { id: $scope.location.id },
          { location: $scope.location },
          function() {
            $('.upload_button')
              .removeAttr('disabled')
              .text('Update Local Profile CSV');
          }
        );
      });
    return $scope;
  };

  return Uploads;
});
