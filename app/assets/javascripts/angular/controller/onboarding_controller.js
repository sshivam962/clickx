clickxApp.controller('OnBoarding', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  '$location',
  '$routeParams',
  '$window',
  'LiveTrackingForm',
  'User',
  'Users',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    $location,
    $routeParams,
    $window,
    LiveTrackingForm,
    User,
    Users
  ) {
    var current_fs, next_fs, previous_fs;
    var left, opacity;
    var animating;

    $scope.website = {};
    $rootScope.onboarding = true;
    $scope.current_business = current_business;
    $rootScope.current_business_domain = null;
    $scope.set_business(current_business);

    $scope.current_user = { first_name: '', last_name: '', phone: '' };

    Users.get_user({}, function(response) {
      $scope.current_user.first_name = response.first_name;
      $scope.current_user.last_name = response.last_name;
      $scope.current_user.phone = response.phone;
    });

    $scope.addDomain = function (domain, event) {
      if (/([a-z])([a-z0-9]+\.)*[a-z0-9]+\.[a-z.]+/g.test(domain)) {
        domain = domain.replace(/(^\w+:|^)\/\//, "");
        Business.add_domain(
          { id: $scope.business.id, domain: domain },
          function (response) {
            $scope.website = response.website;
            $rootScope.current_business_domain = domain;
            $scope.next(event);
          }
        );
      } else {
        toastr.error("Please enter a valid domain");
      }
    };

    $scope.goToDashboard = function () {
      $rootScope.onboarding = false;
      window.location.href = "/b/dashboard";
    };

    $scope.next = function (event, div) {
      if (div == "domain_div") {
        $rootScope.onboarding = false;
        window.location.href = "/b/dashboard";
      }
      if (animating) return false;
      animating = true;
      current_fs = angular.element(event.target).parent();
      next_fs = angular.element(event.target).parent().next();
      $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");
      next_fs.show();
      current_fs.animate(
        { opacity: 0 },
        {
          step: function (now, mx) {
            scale = 1 - (1 - now) * 0.1;
            left = now * 2 + "%";
            opacity = 1 - now;
            current_fs.css({ transform: "scale(" + scale + ")" });
            next_fs.css({ left: left, opacity: opacity });
          },
          duration: 800,
          complete: function () {
            current_fs.hide();
            animating = false;
          },
          easing: "easeInOutBack",
        }
      );
    };

    $scope.prev = function () {
      if (animating) return false;
      animating = true;
      current_fs = $(this).parent();
      previous_fs = $(this).parent().prev();

      $("#progressbar li")
        .eq($("fieldset").index(current_fs))
        .removeClass("active");
      previous_fs.show();
      current_fs.animate(
        { opacity: 0 },
        {
          step: function (now, mx) {
            scale = 0.9 + (1 - now) * 0.1;
            left = (1 - now) * 2 + "%";
            opacity = 1 - now;
            current_fs.css({ left: left });
            previous_fs.css({
              transform: "scale(" + scale + ")",
              opacity: opacity,
            });
          },
          duration: 800,
          complete: function () {
            current_fs.hide();
            animating = false;
          },
          easing: "easeInOutBack",
        }
      );
    };

    $scope.sendMail = function (email) {
      if (email) {
        LiveTrackingForm.send_to_developer(
          { bId: $routeParams.business_id, tId: $scope.website.id },
          {
            email: email,
            snippet: $scope.js_code,
          },
          function (result) {
            toastr.success("Email successfully sent", "Success");
          },
          function (error) {
            toastr.error(error.statusText);
          }
        );
      } else {
        toastr.error("Please provide an Email");
      }
    };

    $scope.UpdateUser = function(event) {
      User.update_basic_info(
        { id: $rootScope.current_user_id, user: $rootScope.current_user },
        function(response) {
          if (response.status == 200) {
            $scope.next(event);
          } else {
            toastr.error(response.errors.join('<br>'), 'Error');
          }
        }
      );
    };
  }
]);
