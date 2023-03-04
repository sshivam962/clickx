clickxApp.factory('User', [
  '$resource',
  function($resource) {
    return $resource(
      '/users/:id.json',
      {},
      {
        resend_invitation: {
          url: '/users/:id/resend_invitation.json',
          method: 'PUT',
          params: { id: '@id' }
        },
        delete: { method: 'DELETE', params: { id: '@id' } },
        sign_out: { url: '/users/sign_out', method: 'GET' },
        send_email_alert: {
          url: '/admin_users/set_email_alert',
          method: 'POST',
          params: {
            id: '@id',
            send_mail: '@send_mail'
          }
        },
        update_basic_info: {
          url: '/users/:id/update_basic_info.json',
          method: 'PUT',
          params: { id: '@id' }
        }
      }
    );
  }
]);

clickxApp.factory('Users', [
  '$resource',
  function($resource) {
    return $resource(
      '/users/invitation.json',
      {},
      {
        invite: { method: 'POST' },
        admin_users: {
          url: '/users/:user_id/admin_users',
          method: 'GET',
          params: { user_id: '@user_id' },
          isArray: true
        },
        get_businesses: {
          url: '/users/:user_id/get_businesses',
          method: 'GET',
          params: { user_id: '@user_id' },
          isArray: true
        },
        get_user: { url: '/users/get_user', method: 'GET' },
        set_business: {
          url: '/change_current_business/:business_id',
          method: 'GET',
          params: { business_id: '@business_id' }
        },
        agency_admin: {
          url: '/agencies/agency_admins',
          method: 'GET',
          params: { id: '@id' },
          isArray: true
        },
        get_business_users: {
          url: '/users/business_users',
          method: 'GET',
          isArray: true
        }
      }
    );
  }
]);
