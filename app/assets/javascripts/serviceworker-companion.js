'use strict';

// if (navigator.serviceWorker) {
//   navigator.serviceWorker
//     .register("/serviceworker.js", { scope: "./" })
//     .then(function(reg) {
//       console.log("[Companion]", "Service worker registered!");
//     });
// }

// if ("serviceWorker" in navigator) {
//   console.log("Service Worker is supported");
//   navigator.serviceWorker
//     .register("/serviceworker.js")
//     .then(function(registration) {
//       console.log("Successfully registered!", ":^)", registration);
//     //   registration.pushManager
//     //     .subscribe({
//     //       userVisibleOnly: true,
//     //       applicationServerKey: window.vapidPublicKey
//     //     })
//     //     .then(function(subscription) {
//     //       console.log("endpoint:", subscription.endpoint);
//     //       $.post("/webpush_subscriptions", {
//     //         subscription: subscription.toJSON()
//     //       });
//     //       console.log(subscription.toJSON());
//     //     });
//     })
//     .catch(function(error) {
//       console.log("Registration failed", ":^(", error);
//     });
// }
var pushCheckbox = document.querySelector('.js-push-toggle-checkbox');

function registerServiceWorker() {
  return navigator.serviceWorker.register('serviceworker.js', { scope: "./" }).then(function (registration) {
    console.log('Service worker successfully registered.');
    return registration;
  }).catch(function (err) {
    console.error('Unable to register service worker.', err);
  });
}

function getSWRegistration() {
  return navigator.serviceWorker.register('serviceworker.js', { scope: "./" });
}
function askPermission() {
  return new Promise(function (resolve, reject) {
    var permissionResult = Notification.requestPermission(function (result) {
      resolve(result);
    });

    if (permissionResult) {
      permissionResult.then(resolve, reject);
    }
  }).then(function (permissionResult) {
    if (permissionResult !== 'granted') {
      throw new Error('We weren\'t granted permission.');
    }
  });
}

function subscribeUserToPush() {
  return getSWRegistration().then(function (registration) {
    var subscribeOptions = {
      userVisibleOnly: true,
      applicationServerKey: window.vapidPublicKey
    };

    return registration.pushManager.subscribe(subscribeOptions);
  }).then(function (pushSubscription) {
    console.log('Received PushSubscription: ', JSON.stringify(pushSubscription));
    return pushSubscription;
  });
}

/**
 * Using `Notification.permission` directly can be slow (locks on the main
 * thread). Using the permission API with a fallback to
 * `Notification.permission` is preferable.
 * @return {Promise<String>} Returns a promise that resolves to a notification
 * permission state string.
 */
/**** START get-permission-state ****/
function getNotificationPermissionState() {
  if (navigator.permissions) {
    return navigator.permissions.query({ name: 'notifications' }).then(function (result) {
      return result.state;
    });
  }

  return new Promise(function (resolve) {
    resolve(Notification.permission);
  });
}

function unsubscribeUserFromPush() {
  return registerServiceWorker().then(function (registration) {
    // Service worker is active so now we can subscribe the user.
    return registration.pushManager.getSubscription();
  }).then(function (subscription) {
    if (subscription) {
      return subscription.unsubscribe();
    }
  }).then(function (subscription) {
    pushCheckbox.disabled = false;
    pushCheckbox.checked = false;
  }).catch(function (err) {
    console.error('Failed to subscribe the user.', err);
    getNotificationPermissionState().then(function (permissionState) {
      pushCheckbox.disabled = permissionState === 'denied';
      pushCheckbox.checked = false;
    });
  });
}

function sendSubscriptionToBackEnd(subscription) {
  return fetch('/webpush_subscriptions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    credentials: "same-origin",
    body: JSON.stringify({ subscription: subscription.toJSON() })
  }).then(function (response) {
    if (!response.ok) {
      throw new Error('Bad status code from server.');
    }

    return response.json();
  }).then(function (responseData) {
    if (!(responseData.endpoint && responseData.auth)) {
      throw new Error('Bad response from server.');
    }
  });
}

function setUpPush() {
  return Promise.all([registerServiceWorker(), getNotificationPermissionState()]).then(function (results) {
    var registration = results[0];
    var currentPermissionState = results[1];

    if (currentPermissionState === 'denied') {
      console.warn('The notification permission has been blocked. Nothing we can do.');
      pushCheckbox.disabled = true;
      return;
    }

    pushCheckbox.addEventListener('change', function (event) {
      // Disable UI until we've handled what to do.
      event.target.disabled = true;

      if (event.target.checked) {
        // Just been checked meaning we need to subscribe the user
        // Do we need to wait for permission?
        var promiseChain = Promise.resolve();
        if (currentPermissionState !== 'granted') {
          promiseChain = askPermission();
        }

        promiseChain.then(subscribeUserToPush).then(function (subscription) {
          if (subscription) {
            return sendSubscriptionToBackEnd(subscription).then(function () {
              return subscription;
            });
          }

          return subscription;
        }).then(function (subscription) {
          // We got a subscription AND it was sent to our backend,
          // re-enable our UI and set up state.
          pushCheckbox.disabled = false;
          pushCheckbox.checked = subscription !== null;
        }).catch(function (err) {
          console.error('Failed to subscribe the user.', err);

          // An error occured while requestion permission, getting a
          // subscription or sending it to our backend. Re-set state.
          pushCheckbox.disabled = currentPermissionState === 'denied';
          pushCheckbox.checked = false;
        });
      } else {
        // Just been unchecked meaning we need to unsubscribe the user
        unsubscribeUserFromPush();
      }
    });

    if (currentPermissionState !== 'granted') {
      // If permission isn't granted than we can't be subscribed for Push.
      pushCheckbox.disabled = false;
      return;
    }

    return registration.pushManager.getSubscription().then(function (subscription) {
      pushCheckbox.checked = subscription !== null;
      pushCheckbox.disabled = false;
    });
  }).catch(function (err) {
    console.log('Unable to register the service worker: ' + err);
  });
}

setUpPush();
