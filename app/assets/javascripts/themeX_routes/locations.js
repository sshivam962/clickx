angular.module('clickxApp.Locations', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/locations', {
      templateUrl: 'themeX/locations/index.html',
      controller: 'LocationList',
      title: 'Locations | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Listings', link: '/#/locations' }
        ]
      }
    });
    $routeProvider.when('/:business_id/locations_list/', {
      templateUrl: 'themeX/local_profile/index.html',
      controller: 'LocalProfileLocations',
      title: 'Local Profile Locations | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          {
            name: 'Locations Listings',
            link: '/#/{{business_id}}/locations_list'
          }
        ]
      }
    });
    $routeProvider.when('/:business_id/locations/:location_id/listings/', {
      templateUrl: 'themeX/local_profile/listings.html',
      controller: 'LocalProfile',
      title: ' Local Profile | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          {
            name: 'Locations Listings',
            link: '/#/{{business_id}}/locations_list'
          },
          {
            name: 'Listings',
            link: '/{{business_id}}/locations/{{location_id}}/listings/'
          }
        ]
      }
    });
    $routeProvider.when('/locations/:id/clickx_local', {
      templateUrl: 'themeX/local_profile/clickx_local.html',
      controller: 'LocationClickxLocal',
      title: 'Local Listings | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Listings', link: '/#/{{business_id}}/locations_list' },
          {
            name: 'Local Listings',
            link: '/#/{{business_id}}/locations/{{id}}/clickx_local'
          }
        ]
      }
    });
    $routeProvider.when('/locations/:location_id/add_coupon', {
      templateUrl: 'themeX/locations/add_coupon.html',
      controller: 'ReviewCouponCtrl',
      title: 'Review Coupon | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Listings', link: '/#/locations' },
          { name: 'Review Responses', link: '/#/locations/{{id}}/add_coupon' }
        ]
      }
    });
    $routeProvider.when('/locations/new', {
      templateUrl: 'themeX/locations/new.html',
      controller: 'NewLocation',
      title: 'Add New Location | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Listings', link: '/#/locations' },
          { name: 'Add New Location', link: '/#/locations/new' }
        ]
      }
    });
    $routeProvider.when('/locations/:id/edit', {
      templateUrl: 'themeX/locations/edit.html',
      controller: 'UpdateLocation',
      title: 'Location Update | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Listings', link: '/#/locations' },
          { name: 'Edit Location', link: '/#/locations/{{id}}/edit' }
        ]
      }
    });
  }
]);
