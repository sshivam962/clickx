/**
 *  CLICKX MD ACCORDION
 *  Version: CMDA 1.0.0
 *  @description Replace for UI Accordion
 *  @see https://github.com/angular-ui/bootstrap/blob/master/src/accordion/accordion.js
 *  @copyright clickx.io
 *
 */

'use strict';




if(typeof angular !== "undefined") {

  /**
   * UI BOOTSTRAP TAB INDEX
   */

  angular.module('bmd.bootstrap', ['bmd.bootstrap.tabindex', 'bmd.bootstrap.collapse',
    'bmd.bootstrap.accordion','bmd.bootstrap.alert']);

  angular.module('bmd.bootstrap.alert', [])
    .controller('BmdAlertController', ['$scope', '$element', '$attrs', '$interpolate', '$timeout', function($scope, $element, $attrs, $interpolate, $timeout) {
      $scope.closeable = !!$attrs.close;
      $element.addClass('alert');
      $attrs.$set('role', 'alert');
      if ($scope.closeable) {
        $element.addClass('alert-dismissible');
      }
      var dismissOnTimeout = angular.isDefined($attrs.dismissOnTimeout) ?
        $interpolate($attrs.dismissOnTimeout)($scope.$parent) : null;

      if (dismissOnTimeout) {
        $timeout(function() {
          $scope.close();
        }, parseInt(dismissOnTimeout, 10));
      }
    }])
    .directive('bmdAlert', function() {
      return {
        controller: 'BmdAlertController',
        controllerAs: 'alert',
        restrict: 'A',
        templateUrl: function(element, attrs) {
          return attrs.templateUrl || 'themeX_helpers/templates/clx-alert.html';
        },
        transclude: true,
        scope: {
          close: '&'
        }
      };
    });


  angular.module('bmd.bootstrap.tabindex', [])
    .directive('bmdTabindexToggle', function () {
      return {
        restrict: 'A',
        link: function (scope, elem, attrs) {
          attrs.$observe('disabled', function (disabled) {
            attrs.$set('tabindex', disabled ? -1 : null);
          });
        }
      };
    });

  /**
   * UI BOOTSTRAP COLLAPSE
   */
  angular.module('bmd.bootstrap.collapse', [])
    .directive('bmdCollapse', ['$animate', '$q', '$parse', '$injector', function ($animate, $q, $parse, $injector) {
      var $animateCss = $injector.has('$animateCss') ? $injector.get('$animateCss') : null;
      return {
        link: function (scope, element, attrs) {
          var expandingExpr = $parse(attrs.expanding),
            expandedExpr = $parse(attrs.expanded),
            collapsingExpr = $parse(attrs.collapsing),
            collapsedExpr = $parse(attrs.collapsed),
            horizontal = false,
            css = {},
            cssTo = {};

          init();

          function init() {
            horizontal = !!('horizontal' in attrs);
            if (horizontal) {
              css = {
                width: ''
              };
              cssTo = {width: '0'};
            } else {
              css = {
                height: ''
              };
              cssTo = {height: '0'};
            }
            if (!scope.$eval(attrs.bmdCollapse)) {
              element.addClass('in')
                .addClass('collapse')
                .attr('aria-expanded', true)
                .attr('aria-hidden', false)
                .css(css);
            }
          }

          function getScrollFromElement(element) {
            if (horizontal) {
              return {width: element.scrollWidth + 'px'};
            }
            return {height: element.scrollHeight + 'px'};
          }

          function expand() {
            if (element.hasClass('collapse') && element.hasClass('in')) {
              return;
            }

            $q.when(expandingExpr(scope))
              .then(function () {
                element.removeClass('collapse')
                  .addClass('collapsing')
                  .attr('aria-expanded', true)
                  .attr('aria-hidden', false);

                if ($animateCss) {
                  $animateCss(element, {
                    addClass: 'in',
                    easing: 'ease',
                    css: {
                      overflow: 'hidden'
                    },
                    to: getScrollFromElement(element[0])
                  }).start()['finally'](expandDone);
                } else {
                  $animate.addClass(element, 'in', {
                    css: {
                      overflow: 'hidden'
                    },
                    to: getScrollFromElement(element[0])
                  }).then(expandDone);
                }
              }, angular.noop);
          }

          function expandDone() {
            element.removeClass('collapsing')
              .addClass('collapse')
              .css(css);
            expandedExpr(scope);
          }

          function collapse() {
            if (!element.hasClass('collapse') && !element.hasClass('in')) {
              return collapseDone();
            }

            $q.when(collapsingExpr(scope))
              .then(function () {
                element
                // IMPORTANT: The width must be set before adding "collapsing" class.
                // Otherwise, the browser attempts to animate from width 0 (in
                // collapsing class) to the given width here.
                  .css(getScrollFromElement(element[0]))
                  // initially all panel collapse have the collapse class, this removal
                  // prevents the animation from jumping to collapsed state
                  .removeClass('collapse')
                  .addClass('collapsing')
                  .attr('aria-expanded', false)
                  .attr('aria-hidden', true);

                if ($animateCss) {
                  $animateCss(element, {
                    removeClass: 'in',
                    to: cssTo
                  }).start()['finally'](collapseDone);
                } else {
                  $animate.removeClass(element, 'in', {
                    to: cssTo
                  }).then(collapseDone);
                }
              }, angular.noop);
          }

          function collapseDone() {
            element.css(cssTo); // Required so that collapse works when animation is disabled
            element.removeClass('collapsing')
              .addClass('collapse');
            collapsedExpr(scope);
          }

          scope.$watch(attrs.bmdCollapse, function (shouldCollapse) {
            if (shouldCollapse) {
              collapse();
            } else {
              expand();
            }
          });
        }
      };
    }]);

  /**
   * UI BOOTSTRAP ACCORDION
   */
  angular.module('bmd.bootstrap.accordion', ['bmd.bootstrap.collapse', 'bmd.bootstrap.tabindex'])

    .constant('bmdAccordionConfig', {
      closeOthers: true
    })

    .controller('BmdAccordionController', ['$scope', '$attrs', 'bmdAccordionConfig', function ($scope, $attrs, accordionConfig) {
      // This array keeps track of the accordion groups
      this.groups = [];

      // Ensure that all the groups in this accordion are closed, unless close-others explicitly says not to
      this.closeOthers = function (openGroup) {
        var closeOthers = angular.isDefined($attrs.closeOthers) ?
          $scope.$eval($attrs.closeOthers) : accordionConfig.closeOthers;
        if (closeOthers) {
          angular.forEach(this.groups, function (group) {
            if (group !== openGroup) {
              group.isOpen = false;
            }
          });
        }
      };

      // This is called from the accordion-group directive to add itself to the accordion
      this.addGroup = function (groupScope) {
        var that = this;
        this.groups.push(groupScope);

        groupScope.$on('$destroy', function (event) {
          that.removeGroup(groupScope);
        });
      };

      // This is called from the accordion-group directive when to remove itself
      this.removeGroup = function (group) {
        var index = this.groups.indexOf(group);
        if (index !== -1) {
          this.groups.splice(index, 1);
        }
      };
    }])

    // The accordion directive simply sets up the directive controller
    // and adds an accordion CSS class to itself element.
    .directive('bmdAccordion', function () {
      return {
        controller: 'BmdAccordionController',
        controllerAs: 'accordion',
        transclude: true,
        restrict:'EAC',
        templateUrl: function (element, attrs) {
          return attrs.templateUrl || 'themeX_helpers/templates/clx-accordion.html';
        }
      };
    })

    // The accordion-group directive indicates a block of html that will expand and collapse in an accordion
    .directive('bmdAccordionGroup', function () {
      return {
        require: '^bmdAccordion',         // We need this directive to be inside an accordion
        transclude: true,              // It transcludes the contents of the directive into the template
        restrict: 'EA',
        templateUrl: function (element, attrs) {
          return attrs.templateUrl || 'themeX_helpers/templates/clx-accordion-group.html';
        },
        scope: {
          heading: '@',               // Interpolate the heading attribute onto this scope
          panelClass: '@?',           // Ditto with panelClass
          isOpen: '=?',
          isDisabled: '=?'
        },
        controller: function () {
          this.setHeading = function (element) {
            this.heading = element;
          };
        },
        link: function (scope, element, attrs, accordionCtrl) {
          element.addClass('panel');
          accordionCtrl.addGroup(scope);

          scope.openClass = attrs.openClass || 'panel-open';
          scope.panelClass = attrs.panelClass || 'panel-default';
          scope.$watch('isOpen', function (value,oldValue) {
            element.toggleClass(scope.openClass, !!value);
            if (value) {
              accordionCtrl.closeOthers(scope);
            }
            if(oldValue!==value){ // at the begining  both are false
              scope.$emit('bmd.accordion',{
                open_status: value,
                element: element
              })
            }

          });

          scope.toggleOpen = function ($event) {
            if (!scope.isDisabled) {
              if (!$event || $event.which === 32) {
                scope.isOpen = !scope.isOpen;
              }
            }
          };

          var id = 'accordiongroup-' + scope.$id + '-' + Math.floor(Math.random() * 10000);
          scope.headingId = id + '-tab';
          scope.panelId = id + '-panel';
        }
      };
    })

    // Use accordion-heading below an accordion-group to provide a heading containing HTML
    .directive('bmdAccordionHeading', function () {
      return {
        transclude: true,   // Grab the contents to be used as the heading
        template: '',       // In effect remove this element!
        replace: true,
        require: '^bmdAccordionGroup',
        restrict:'EA',
        link: function (scope, element, attrs, accordionGroupCtrl, transclude) {
          // Pass the heading to the accordion-group controller
          // so that it can be transcluded into the right place in the template
          // [The second parameter to transclude causes the elements to be cloned so that they work in ng-repeat]
          accordionGroupCtrl.setHeading(transclude(scope, angular.noop));
        }
      };
    })

    // Use in the accordion-group template to indicate where you want the heading to be transcluded
    // You must provide the property on the accordion-group controller that will hold the transcluded element
    .directive('bmdAccordionTransclude', function () {
      return {
        require: '^bmdAccordionGroup',
        link: function (scope, element, attrs, controller) {
          scope.$watch(function () {
            return controller[attrs.bmdAccordionTransclude];
          }, function (heading) {
            if (heading) {
              var elem = angular.element(element[0].querySelector(getHeaderSelectors()));
              elem.html('');
              elem.append(heading);
            }
          });
        }
      };

      function getHeaderSelectors() {
        return 'bmd-accordion-header,' +
          'data-bmd-accordion-header,' +
          'x-bmd-accordion-header,' +
          'bmd\\:accordion-header,' +
          '[bmd-accordion-header],' +
          '[data-bmd-accordion-header],' +
          '[x-bmd-accordion-header]';
      }
    });
}