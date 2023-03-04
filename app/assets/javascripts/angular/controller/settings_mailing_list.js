clickxApp.controller('SettingsMailingList', [
  '$scope',
  '$rootScope',
  'Business',
  '$mdConstant',
  function($scope, $rootScope, Business, $mdConstant) {
    $scope.current_template = 'themeX/settings/mailing_list.html';
    $scope.settings_tab = 'mailing_list';
    $scope.business_content = {};
    $scope.business_content['contact_mailing_list'] = [];
    $scope.error = '';

    $scope.seperatorKeys = [$mdConstant.KEY_CODE.ENTER, $mdConstant.KEY_CODE.COMMA, $mdConstant.KEY_CODE.SPACE];
    $scope.addChips = function(chips) {
      $scope.business_content['contact_mailing_list']
      var chipsArray = chips.split(',');
      angular.forEach(chipsArray, function(chip) {
        if ($scope.business_content['contact_mailing_list'].indexOf(chip) < 0) {
          $scope.business_content['contact_mailing_list'].push(chip);
        }
      });
      return null;
    };

    var getBusinessContent = Business.show(
      { id: $rootScope.current_business },
      function(result) {
        $scope.business_content = result;
      },
      Utility.logError
    );

    var findInvalidEmails = function(emails) {
      var invalid_emails = [];
      _.each(emails, function(email) {
        if (!Utility.emailValidator(email)) {
          invalid_emails.push(email);
        }
      });

      return invalid_emails;
    };

    var updateBusiness = function() {
      Business.update_business(
        { id: $rootScope.current_business },
        { business: $scope.business_content },
        function(response) {
          if (response.status == 200) {
            $scope.error = '';
            $scope.default_content = $.extend(
              $scope.business_content,
              response.data
            );
          } else {
            $scope.error = response.errors[0];
          }
        }
      ),
        Utility.logError;
    };

    $scope.updateMailingList = function(e) {
      e.preventDefault();
      var emails = $scope.business_content.contact_mailing_list;
      var invalid_emails = findInvalidEmails(emails);

      if (!invalid_emails.length) {
        updateBusiness();
      } else {
        $scope.error = 'Invalid Emails - ' + invalid_emails.join(', ');
      }
    };
  }
]);
