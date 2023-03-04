clickxApp.controller('LocalProfile', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  '$location',
  '$routeParams',
  'Locations',
  '$localStorage',
  'Location',
  '$window',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    $location,
    $routeParams,
    Locations,
    $localStorage,
    Location,
    $window
  ) {
    $rootScope.current_controller = 'home';
    $scope.rows_per_page = 10;
    $scope.listings = [];

    Location.show({ id: $routeParams.location_id }, function(resp) {
      $scope.location = resp;

      if (!!$scope.location.yext_store_id) {
        Location.get_yext_listings(
          { id: $routeParams.location_id },
          function(resp) {
            _.each(resp.data.listings, function(listing) {
              if (listing.status == 'LIVE') {
                $scope.listings.push(listing);
              } else {
                listing.status = 'LIVE';
                $scope.listings.push(listing);
              }
            });
          },
          function(error) {
            'use strict';
            toastr.error(error.statusText);
          }
        );

        Location.get_yext_info(
          { id: $routeParams.location_id },
          function(resp) {
            $scope.location_info = resp.data;
          },
          function(error) {
            'use strict';
            toastr.error(error.statusText);
          }
        );
      }

      if (!!$scope.location.bright_local_campaign_id) {
        Location.get_bright_local_listing(
          { id: $routeParams.location_id },
          function(result) {
            if (result.status == 200 && Object.keys(result.data).length > 0) {
              $scope.listings = $scope.listings || [];
              _.each(result.data, function(row, index) {
                // if (!row.status == 'Live') {
                //   row.status = 'Live';
                // }
                row.status = row.status.toUpperCase();
                row.site = index;
                $scope.listings.push(row);
              });
            }
          },
          function(error) {
            console.log(error);
          }
        );
      }

      $scope.location.social_links.forEach(function(link) {
        if (link.link_type == 'Google+ Local Page') {
          var listing = {
            locationId: '',
            screenshotUrl: '',
            publisherId: 'GOOGLE+',
            status: 'LIVE',
            url: link.link
          };
          $scope.listings.unshift(listing);
        }
      });

      $scope.copyListings = $scope.listings;
    });

    $scope.site_class_name = function(name) {
      if (typeof name == 'undefined') return 'default';
      //if first character is numeric then get its string representation else just replace its . and spaces
      var num_words = [
        'zero',
        'one',
        'two',
        'three',
        'four',
        'five',
        'six',
        'seven',
        'eight',
        'nine'
      ];
      if (name.match(/^[0-9]/) != null) {
        first_char = parseInt(name[0]);
        first_char = num_words[first_char];
        name = first_char + name.substring(1);
      }
      name = name.toLowerCase().replace(/\W/g, '');
      return name;
    };

    $scope.go_back = function() {
      $window.history.back();
    };
  }
]);

clickxApp.controller('LocalProfileLocations', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  '$location',
  '$routeParams',
  'Locations',
  '$localStorage',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    $location,
    $routeParams,
    Locations,
    $localStorage
  ) {
    $rootScope.current_controller = 'home';
    $scope.locations = [];
    $scope.markers = [];
    $scope.business_id = $routeParams.business_id;
    Locations.for_local_profile({}, function(data) {
      $scope.locations = data;
      $localStorage.locations = $scope.locations;
      if ($scope.locations.length == 0) {
        $scope.empty_location = true;
      }
      load_maps();
    });
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

      _.each($localStorage.locations, function(location) {
        createMarker(location);
      });

      if ($localStorage.locations.length > 0) {
        $scope.map.fitBounds(bounds);
        $scope.map.setCenter(bounds.getCenter());
      }

      $scope.mapTM($scope.map);
    }

    google.maps.event.addDomListener(window, 'resize', function() {
      load_maps();
    });

    $scope.openInfoWindow = function(e, selectedMarker) {
      e.preventDefault();
      google.maps.event.trigger(selectedMarker, 'click');
    };
  }
]);

clickxApp.controller('LocalProfiles', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  '$location',
  '$routeParams',
  'Locations',
  '$localStorage',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    $location,
    $routeParams,
    Locations,
    $localStorage
  ) {
    $rootScope.current_controller = 'home';
    $scope.locations = [];
    $scope.business_id = $routeParams.business_id;
    if ($routeParams.business_id) {
      Locations.for_local_profile({}, function(data) {
        $scope.locations = data;
        if ($scope.locations.length == 0) {
          $scope.empty_location = true;
        }
      });
    }
  }
]);
