clickxApp.controller('LocationList', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Locations',
  'Location',
  '$location',
  'Business',
  '$window',
  '$mdDialog',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Locations,
    Location,
    $location,
    Business,
    $window,
    $mdDialog
  ) {
    $scope.locations = [];
    $scope.business;
    $scope.reviews_url = reviews_url;
    var bis_id;
    Locations.query({}, function(response) {
      load_maps();
      _.each(response, function(location) {
        $scope.locations.push(location);
        bis_id = location.business_id;
        if (location.lat != null && location.lng != null) {
          createMarker(location);

          $scope.map.fitBounds(bounds);
          $scope.map.setCenter(bounds.getCenter());
        }
      });
      $scope.business = Business.get({ id: bis_id });
    });

    $scope.colors = ['blue', 'red'];
    $rootScope.current_controller = 'locations';
    $scope.markers = [];

    var bounds = new google.maps.LatLngBounds();

    var createMarker = function(info) {
      var marker = new google.maps.Marker({
        map: $scope.map,
        animation: google.maps.Animation.DROP,
        position: new google.maps.LatLng(info.lat, info.lng),
        title: info.name
      });
      bounds.extend(marker.position);

      marker.content =
        '<div class="infoWindowContent">' +
        info.address +
        '<br>' +
        '<a href = "http://' +
        info.website +
        '">' +
        info.website +
        '</a>' +
        '</div>';

      var infoWindow = new google.maps.InfoWindow();
      google.maps.event.addListener(marker, 'click', function() {
        infoWindow.setContent('<h2>' + marker.title + '</h2>' + marker.content);
        infoWindow.open($scope.map, marker);
      });
      $scope.markers.push(marker);
    };

    function load_maps() {
      var mapOptions = {
        zoom: 4,
        center: new google.maps.LatLng(40.0, -98.0),
        mapTypeId: google.maps.MapTypeId.TERRAIN
      };
      $scope.map = new google.maps.Map(
        document.getElementById('googlemap'),
        mapOptions
      );
      $scope.mapTM($scope.map);
    }

    google.maps.event.addDomListener(window, 'resize', function() {
      load_maps();
    });

    $scope.openInfoWindow = function(e, selectedMarker) {
      e.preventDefault();
      google.maps.event.trigger(selectedMarker, 'click');
    };

    $scope.deleteLocation = function(locId) {
      var confirm = $mdDialog
        .confirm()
        .title('Delete this Location')
        .textContent('Are you sure?')
        .ok('Yes')
        .cancel('Cancel');

      $mdDialog.show(confirm).then(
        function() {
          $scope.deleteThisLocation(locId);
        },
        function() {}
      );
    };

    $scope.deleteThisLocation = function(locId) {
      Location.delete({ id: locId }, function() {
        $scope.locations = Locations.query();
        toastr.success('Location Deleted Successfully', 'Success!');
        $location.path('/locations');
      });
    };

    $scope.onSuccess = function(e) {
      toastr.success('Review url copied to clipboard', 'Success!');
      e.clearSelection();
      /* Open a new tab */
      if (e.text) {
        $window.open(e.text, '_blank');
      } else {
        var targetUrl = $(e.trigger).data('target-url');
        $window.open(targetUrl, '_blank');
      }
    };

    $scope.onError = function(e) {
      console.error('Action:', e.action);
      console.error('Trigger:', e.trigger);
      var targetUrl = $(e.trigger).data('target-url');
      if (!targetUrl) {
        targetUrl = $(e.target).attr('data-target-url');
      }
      $window.open(targetUrl, '_blank');
    };

    /**
     * @description Open a Location review modal with embedded code
     * @param event
     * @param location
     * @todo Same functionality already present in review page, at least same template can be use
     */
    $scope.openLocationReviewModal = function(event, location) {
      event.preventDefault();
      $mdDialog
        .show({
          templateUrl: 'reviews-form-location-modal.html',
          controller: [
            '$scope',
            '$mdDialog',
            '$sce',
            'location',
            function($scope, $mdDialog, $sce, location) {
              $scope.loc = location;
              $scope.closeModal = function() {
                $mdDialog.cancel('cancel');
              };

              /**
               * @description trusted html content in angular use `$sce` service
               * @param src
               * @todo Make it as a helper function or put in root scope
               */
              $scope.trustSrc = function(src) {
                return $sce.trustAsResourceUrl(src);
              };
            }
          ],
          locals: {
            location: location
          }
        })
        .finally(function() {
          console.log('Close modal');
        });
    };
  }
]);

clickxApp.controller('LocationView', [
  '$scope',
  '$rootScope',
  '$resource',
  'Location',
  '$location',
  '$routeParams',
  function($scope, $rootScope, $resource, Location, $location, $routeParams) {
    $scope.location = Location.get({ id: $routeParams.id });
    $rootScope.current_controller = 'locations';
  }
]);

clickxApp.controller('ReviewCouponCtrl', [
  '$scope',
  '$rootScope',
  '$routeParams',
  '$location',
  'Location',
  '$upload',
  function($scope, $rootScope, $routeParams, $location, Location, $upload) {
    $scope.location = [];
    Location.get({ id: $routeParams.location_id }, function(data) {
      $scope.location = data;
    });

    $scope.$watch('location.positive_review_coupon_file', function(
      newValue,
      oldValue
    ) {
      if (
        newValue !== oldValue &&
        newValue != null &&
        typeof newValue != 'string'
      ) {
        if (!$scope.location.positive_review_coupon_file) return;

        if (newValue.length > 0) {
          $scope.upload = $upload
            .upload({
              url:
                'https://api.cloudinary.com/v1_1/' +
                $.cloudinary.config().cloud_name +
                '/upload',
              file: newValue,
              fields: {
                upload_preset: $.cloudinary.config().upload_preset,
                folder: 'location_coupons',
                tags: 'coupon',
                context: 'image=' + $scope.location.name
              }
            })
            .progress(function(e) {
              $('.saveBtn')
                .attr('disabled', 'disabled')
                .text('Upaloding Images. Please wait...');
              if (!$scope.$$phase) {
                $scope.$apply();
              }
            })
            .success(function(data, status, headers, config) {
              Location.update(
                { id: $routeParams.location_id },
                {
                  positive_review_coupon: data.secure_url
                },
                function(result) {}
              );
              $rootScope.positive_review_coupon = '';
              $scope.location.positive_review_coupon = data.secure_url;
              $rootScope.positive_review_coupon = data.secure_url;
              if (!$scope.$$phase) {
                $scope.$apply();
              }
            });
        }
      }
    });

    $scope.$watch('location.negative_review_coupon_file', function(
      newValue,
      oldValue
    ) {
      if (
        newValue !== oldValue &&
        newValue != null &&
        typeof newValue != 'string'
      ) {
        if (!$scope.location.negative_review_coupon_file) return;
        if (newValue.length > 0) {
          $scope.upload = $upload
            .upload({
              url:
                'https://api.cloudinary.com/v1_1/' +
                $.cloudinary.config().cloud_name +
                '/upload',
              file: newValue,
              fields: {
                upload_preset: $.cloudinary.config().upload_preset,
                folder: 'location_coupons',
                tags: 'coupon',
                context: 'image=' + $scope.location.name
              }
            })
            .progress(function(e) {
              $('.saveBtn')
                .attr('disabled', 'disabled')
                .text('Uploading Images. Please wait...');
              if (!$scope.$$phase) {
                $scope.$apply();
              }
            })
            .success(function(data, status, headers, config) {
              Location.update(
                { id: $routeParams.location_id },
                {
                  negative_review_coupon: data.secure_url
                },
                function(result) {}
              );

              $rootScope.negative_review_coupon = data.secure_url;
              $scope.location.negative_review_coupon = data.secure_url;
              if (!$scope.$$phase) {
                $scope.$apply();
              }
            });
        }
      }
    });
  }
]);

clickxApp.controller('LocationClickxLocal', [
  '$scope',
  '$rootScope',
  '$routeParams',
  'Location',
  'Businesses',
  function($scope, $rootScope, $routeParams, Location, Businesses) {
    $rootScope.current_controller = 'powerlistings';
    $scope.listings = [];
    $scope.site_ids = [];
    $scope.error_count = 0;

    Businesses.get_site_ids({}, function(resp) {
      $scope.site_ids = resp;
      Location.show({ id: $routeParams.id }, function(resp) {
        $scope.listings = [];
        $scope.location = resp;
        $scope.site_ids.forEach(function(site_id) {
          Location.get_powerlisting(
            { id: $routeParams.id, site_id: site_id },
            function(listing) {
              if (listing.status == 200) {
                if (!listing.body.has_powerlistings) {
                  if (!listing.body.match_address) {
                    $scope.error_count += 1;
                  }
                  if (!listing.body.match_name) {
                    $scope.error_count += 1;
                  }
                  if (!listing.body.match_phone) {
                    $scope.error_count += 1;
                  }
                }
              } else {
                if (!listing.body.has_powerlistings) {
                  $scope.error_count += 3;
                }
              }
              $scope.listings.push(listing);
            }
          );
        });
      });
    });
  }
]);

clickxApp.controller('NewLocation', [
  '$scope',
  '$rootScope',
  '$resource',
  '$http',
  'Locations',
  '$location',
  '$upload',
  'Location',
  '$window',
  '$timeout',
  function(
    $scope,
    $rootScope,
    $resource,
    $http,
    Locations,
    $location,
    $upload,
    Location,
    $window,
    $timeout
  ) {
    $scope.timePickerTemplate = 'timePicker.html';
    $scope.location = {
      name: '',
      address: '',
      city: '',
      state: '',
      country: '',
      zip: '',
      phone: '',
      mobile_phone: '',
      toll_free: '',
      website: '',
      enquiry_email: '',
      fax: '',
      categories: [],
      operational_hours: true,
      payment_methods: [],
      products_services: '',
      brands: '',
      images: '',
      languages: '',
      local_profile_list: '',
      professional_associations: '',
      slogan: '',
      keywords: '',
      newLogo: '',
      is_new: true,
      short_description: '',
      medium_description: '',
      full_description: '',
      long_description: '',
      number_of_users: '',
      year_established: '',
      social_links: [{ link_type: '', link: '' }],
      review_links: [{ link_type: '', link: '' }],
      working_hours: []
    };
    $scope.max_year = parseInt(moment().format('YYYY'));
    $scope.payment_chips = [
      'Visa',
      'Master',
      'Cash',
      'Check',
      'Credit Card',
      'Debit Card'
    ];
    $scope.category_chips = [
      'Web',
      'Mobile',
      'Social Media',
      'Video Marketing',
      'SEO',
      'Blogs'
    ];
    $scope.dzOptions = {
      previewsContainer: false
    };
    $rootScope.review_btn = true;

    $scope.progress_width = function(obj) {
      values = Object.values(obj);
      total = values.length - 4;
      completed = _.compact(values).length;
      return Math.round((completed / total) * 100);
    };

    $scope.dzCallbacks = {
      sending: function(file, xhr, formData) {
        formData.append('upload_preset', $.cloudinary.config().upload_preset);
      },
      addedfile: function(file) {
        $scope.newFile = file;
      },
      success: function(file, response) {
        $scope.upload_resp = response;
      }
    };
    $scope.dzMethods = {};

    $scope.working_days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    /**
     * Invoke when a user click on 'Apply To All', it fetch data from first
     * row
     */
    $scope.workingDayChanges = function(currentValue, index) {
      if (currentValue != 'open') {
        /** If select input value is not open then clear its sibling from, to input values **/
        $scope.location.working_hours[index].from = '';
        $scope.location.working_hours[index].to = '';
      }
      if (index == 0) {
        $scope.firstRowOpen = $scope.location.working_hours[0].status;
        $scope.firstRowStart = $scope.location.working_hours[0].from;
        $scope.firstRowStop = $scope.location.working_hours[0].to;
        if (
          !!$scope.firstRowOpen &&
          !!$scope.firstRowStop &&
          !!$scope.firstRowStart
        ) {
          $scope.showApplyAllLink = true;
        }
      }
    };
    $scope.sameTimeForAllDays = function() {
      if ($scope.showApplyAllLink) {
        $scope.working_days.map(function(value, index) {
          $scope.location.working_hours[index].status = $scope.firstRowOpen;
          $scope.location.working_hours[index].from = $scope.firstRowStart;
          $scope.location.working_hours[index].to = $scope.firstRowStop;
        });
      }
    };
    /** eof sameTimeForAllDays **/

    $rootScope.current_controller = 'locations';
    $scope.$watch('location.files', function(newValue, oldValue) {
      if (!$scope.location.files) return;
      $scope.loading = true;

      $scope.location.files.forEach(function(file) {
        $scope.upload = $upload
          .upload({
            url:
              'https://api.cloudinary.com/v1_1/' +
              $.cloudinary.config().cloud_name +
              '/upload',
            file: file,
            fields: {
              upload_preset: $.cloudinary.config().upload_preset,
              folder: 'location_images',
              tags: 'files',
              context: 'image=' + $scope.location.name
            }
          })
          .progress(function(e) {
            $('.saveBtn')
              .attr('disabled', 'disabled')
              .text('Upaloding Image Please wait...');
            if (!$scope.$$phase) {
              $scope.$apply();
            }
          })
          .success(function(data, status, headers, config) {
            $rootScope.images = $rootScope.images || [];
            $rootScope.images.push(data.secure_url);
            $('.saveBtn')
              .removeAttr('disabled')
              .text('Update Location');
            $scope.loading = false;
            if (!$scope.$$phase) {
              $scope.$apply();
            }
          });
      });
    });

    $scope.save_location = function() {
      if (
        $('#new_locations')
          .parsley()
          .isValid()
      ) {
        $scope.location.images = $scope.location.images || [];
        $scope.location.images.push($rootScope.images);
        $scope.location.images = _.flatten($scope.location.images);
        $scope.location.files = '';
        Locations.create(
          { location: $scope.location },
          function(response) {
            $scope.location.id = response.location.id;
            if (response.status == 201) {
              $rootScope.images = [];
              $scope.location.is_new = false;
              toastr.success('Location Created Successfully', 'Success!');
              $location.path('/locations');
            }
          },
          function(error) {}
        );
      } else {
        $('#new_locations')
          .parsley()
          .validate();
      }
    };

    $scope.$on('$locationChangeSuccess', function(event) {
      $scope.save_location();
      $rootScope.actualLocation = $location.path();
    });

    $scope.go_back = function() {
      $window.history.back();
    };

    $scope.addSocialLink = function() {
      $scope.location.social_links.push({ link_type: '', link: '' });
    };

    $scope.addReviewLink = function() {
      $scope.location.review_links.push({ link_type: '', link: '' });
      if($('.review_links').length >= 1){
        $rootScope.review_btn = false
      } else{
        $rootScope.review_btn = true
      }
    };

    $scope.removeSocialLink = function(index, location) {
      var link = location.social_links[index];
      if (link.id) {
        link._destroy = true;
      } else {
        location.social_links.splice(index, 1);
      }
    };

    $scope.removeReviewLink = function(index, location) {
      var link = location.review_links[index];
      if (link.id) {
        link._destroy = true;
      } else {
        location.review_links.splice(index, 1);
      }
      $rootScope.review_btn = true
    };
  }
]);

clickxApp.controller('UpdateLocation', [
  '$scope',
  '$rootScope',
  '$resource',
  '$http',
  'Location',
  '$location',
  '$routeParams',
  '$upload',
  'Uploads',
  'Business',
  '$window',
  '$timeout',
  function(
    $scope,
    $rootScope,
    $resource,
    $http,
    Location,
    $location,
    $routeParams,
    $upload,
    Uploads,
    Business,
    $window,
    $timeout
  ) {
    $scope.timePickerTemplate = 'timePicker.html';
    $scope.working_days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    $scope.location = {};
    $rootScope.review_btn = true;
    $rootScope.left_page = false;
    Location.get({ id: $routeParams.id }, function(data) {
      $scope.location = data;
      if($scope.location.review_links.length >= 2){
        $rootScope.review_btn = false
      }
      $scope.location.operational_hours = true;
      if ($scope.location.working_hours.length == 0) {
        $scope.location.working_hours = $scope.working_days.map(function(
          value,
          index
        ) {
          return { days: value };
        });
      }
    });
    $rootScope.current_controller = 'locations';
    $scope.max_year = parseInt(moment().format('YYYY'));
    $scope.payment_chips = [
      'Visa',
      'Master',
      'Cash',
      'Check',
      'Credit Card',
      'Debit Card'
    ];
    $scope.category_chips = [
      'Web',
      'Mobile',
      'Social Media',
      'Video Marketing',
      'SEO',
      'Blogs'
    ];
    $scope.dzOptions = {
      previewsContainer: false
    };
    $scope.dzCallbacks = {
      sending: function(file, xhr, formData) {
        formData.append('upload_preset', $.cloudinary.config().upload_preset);
      },
      addedfile: function(file) {
        $scope.newFile = file;
      },
      success: function(file, response) {
        $scope.upload_resp = response;
      }
    };
    $scope.dzMethods = {};

    $scope.progress_width = function(obj) {
      values = Object.values(obj);
      total = values.length - 15;
      completed = _.compact(values).length;
      console.log(total, completed);
      return Math.round((completed / total) * 100);
    };

    /**
     * Invoke when a user click on 'Apply To All', it fetch data from first
     * row
     */
    $scope.showApplyAllLink = true;
    $scope.workingDayChanges = function(currentValue, index) {
      if (currentValue != 'open') {
        /** If select input value is not open then clear its sibling from, to input values **/
        $scope.location.working_hours[index].from = '';
        $scope.location.working_hours[index].to = '';
      }
      if (index == 0) {
        $scope.firstRowOpen = $scope.location.working_hours[0].status;
        $scope.firstRowStart = $scope.location.working_hours[0].from;
        $scope.firstRowStop = $scope.location.working_hours[0].to;
      }
    };

    $scope.sameTimeForAllDays = function() {
      if ($scope.showApplyAllLink) {
        $scope.working_days.map(function(value, index) {
          $scope.location.working_hours[index].status = $scope.firstRowOpen;
          $scope.location.working_hours[index].from = $scope.firstRowStart;
          $scope.location.working_hours[index].to = $scope.firstRowStop;
        });
      }
    };
    /** eof sameTimeForAllDays **/

    $scope.$watch('location.files', function(newValue, oldValue) {
      if (newValue !== oldValue) {
        if (!$scope.location.files) return;
        $scope.loading = true;
        $scope.location.files.forEach(function(file) {
          $scope.upload = $upload
            .upload({
              url:
                'https://api.cloudinary.com/v1_1/' +
                $.cloudinary.config().cloud_name +
                '/upload',
              file: file,
              fields: {
                upload_preset: $.cloudinary.config().upload_preset,
                folder: 'location_images',
                tags: 'files',
                context: 'image=' + $scope.location.name
              }
            })
            .progress(function(e) {
              $('.saveBtn')
                .attr('disabled', 'disabled')
                .text('Upaloding Images. Please wait...');
              if (!$scope.$$phase) {
                $scope.$apply();
              }
            })
            .success(function(data, status, headers, config) {
              $rootScope.images = $rootScope.images || [];
              $rootScope.images.push(data.secure_url);
              $('.saveBtn')
                .removeAttr('disabled')
                .text('Update Location');
              $scope.loading = false;
              if (!$scope.$$phase) {
                $scope.$apply();
              }
            });
        });
      }
    });

    $scope.$watch('location.newLogo', function(newValue, oldValue) {
      if (newValue !== oldValue) {
        if (!$scope.location.newLogo) return;

        $scope.upload = $upload
          .upload({
            url:
              'https://api.cloudinary.com/v1_1/' +
              $.cloudinary.config().cloud_name +
              '/upload',
            file: $scope.location.newLogo,
            fields: {
              upload_preset: $.cloudinary.config().upload_preset,
              folder: 'location_logo',
              tags: 'logo',
              context: 'image=' + $scope.location.name
            }
          })
          .progress(function(e) {
            $('.saveBtn')
              .attr('disabled', 'disabled')
              .text('Upaloding Image Please wait...');
            if (!$scope.$$phase) {
              $scope.$apply();
            }
          })
          .success(function(data, status, headers, config) {
            $rootScope.logo = '';
            $rootScope.logo = data.secure_url;
            $('.saveBtn')
              .removeAttr('disabled')
              .text('Save Location');
            if (!$scope.$$phase) {
              $scope.$apply();
            }
          });
      }
    });

    var updateLocation = function() {
      Location.update(
        { id: $scope.location.id },
        { location: $scope.location },
        function() {
          $rootScope.images = [];
          $rootScope.logo = '';
          $rootScope.local_profile_list = '';

          toastr.success('Location Updated Successfully', 'Success!');
          if ($rootScope.current_role == 'admin') {
            $rootScope.opened_business_id = $scope.location.business_id;
            $location.path('/businesses');
          } else {
            $location.path('/locations');
          }
        },
        function(error) {}
      );
    };

    $scope.update = function() {
      if (
        $('#edit_locations')
          .parsley()
          .isValid()
      ) {
        $scope.location.images = $scope.location.images || [];
        $scope.location.images.push($rootScope.images);
        $scope.location.images = _.flatten($scope.location.images);
        if ($rootScope.logo != '') {
          $scope.location.logo = $rootScope.logo;
        }
        $scope.location.files = '';
        if ($rootScope.local_profile_list != '') {
          $scope.location.local_profile_list = $rootScope.local_profile_list;
        }
        $rootScope.left_page = true;
        updateLocation();
      } else {
        toastr.error('Form is invalid !!! ');
        $('#edit_locations')
          .parsley()
          .validate();
      }
    };

    $scope.addSocialLink = function() {
      $scope.location.social_links.push({ link_type: '', link: '' });
    };

    $scope.addReviewLink = function() {
      $scope.location.review_links.push({ link_type: '', link: '' });
      if($('.review_links').length >= 1){
        $rootScope.review_btn = false
      } else{
        $rootScope.review_btn = true
      }
    };

    $scope.removeSocialLink = function(index, location) {
      var link = location.social_links[index];
      if (link.id) {
        link._destroy = true;
      } else {
        location.social_links.splice(index, 1);
      }
    };

    $scope.removeReviewLink = function(index, location) {
      var link = location.review_links[index];
      if (link.id) {
        link._destroy = true;
      } else {
        location.review_links.splice(index, 1);
      }
      $rootScope.review_btn = true
    };


    $scope.$on('$locationChangeSuccess', function(event, $scope) {
      if (!$rootScope.left_page) {
        updateLocation();
      }
      $rootScope.left_page = false;
      $rootScope.actualLocation = $location.path();
    });

    $scope.go_back = function() {
      $window.history.back();
    };
  }
]);
