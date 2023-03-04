'use strict';

/**
 *
 */
clickxApp.service('Facebook', [
  '$q',
  '$http',
  function($q, $http) {
    this.getLoginStatus = function() {
      FB.getLoginStatus(function(response) {
        if (!response.status === 'conncted') {
          FB.login();
        }
      });
    };
    this.getUserInfo = function() {
      this.getLoginStatus();
      var defer = $q.defer();
      try {
        FB.api('/me', { fields: 'first_name,last_name,bio,email' }, function(
          result
        ) {
          defer.resolve(result);
        });
        return defer.promise;
      } catch (e) {
        return e.message;
      }
    };
    this.postContent = function(message, scope) {
      if (typeof scope == 'undefined') {
        scope = 'public_actions';
      }
      console.log(message);
      this.getLoginStatus();
      try {
        FB.api(
          '/me/feed',
          'post',
          { message: message },
          {
            scope: scope
          }
        );
      } catch (e) {
        return e;
      }
    };
    this.sendFacebookData = function(id, fbAuthData) {
      var defer = $q.defer();
      $http.post('businesses/' + id + '/save_facebook_token', fbAuthData).then(
        function(result) {
          defer.resolve(result);
        },
        function(error) {
          defer.reject(error);
        }
      );
      return defer.promise;
    };
  }
]);
