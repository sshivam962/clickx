/**
 * Created by sibin on 8/12/16.
 */

/* Sidebar for analytic pages */
clickxApp.directive('analyticLinkBox', [
  '$routeParams',
  'clickxHelperService',
  '$interpolate',
  'LiveTrackingWebsite',
  function(
    $routeParams,
    clickxHelperService,
    $interpolate,
    LiveTrackingWebsite
  ) {
    'use strict';
    return {
      restrict: 'C',
      replace: true,
      templateUrl: 'directives/clickx_analytic_sidebar.html',
      link: function(scope, element, attr) {
        scope.defaultLinks = clickxHelperService.getLinkList();
        scope.trackerDetails = {};
        scope.b_id = $routeParams.business_id || $routeParams.b_id;
        scope.t_id = $routeParams.t_id || $routeParams.c_id;
        LiveTrackingWebsite.get(
          {
            business_id: scope.b_id,
            id: scope.t_id
          },
          function(result) {
            scope.trackerDetails = result;
          },
          function(error) {
            toastr.error(error.statusText);
          }
        );
      }
    };
  }
]);
/* Breadcrumb for Analytic Pages */
clickxApp.directive('analyticBreadcrumb', [
  '$interpolate',
  '$routeParams',
  function($interpolate, $routeParams) {
    'use strict';
    return {
      restrict: 'AEC',
      replace: true,
      scope: {
        links: '='
      },
      template: '<ol class="breadcrumb clx-breadcrumb"></ol>',
      link: function(scope, element, attr, ctrl, transclideFn) {
        var linkValues = {
          b_id: $routeParams.b_id || $routeParams.business_id,
          business_id: $routeParams.b_id || $routeParams.business_id,
          c_id: $routeParams.c_id || $routeParams.t_id,
          t_id: $routeParams.t_id || $routeParams.c_id,
          id: $routeParams.id
        };
        var scopeLinks = _.map(scope.links, function(value, link) {
          value.link = $interpolate(value.link)(linkValues);
          return $interpolate(
            "<li><a href='{{link}}'>{{name}}</a></li>"
          )(value);
        });
        if (!_.isEmpty(scopeLinks)) {
          $(element).html(scopeLinks);
        } else {
          $(element).addClass('hidden'); // DO not show id there is nothing
        }
      }
    };
  }
]);
