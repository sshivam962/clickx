clickxApp.directive('jqueryRater', function() {
  var rater = {};
  (rater.restrict = 'A'),
    (rater.scope = {
      rateData: '@rateData',
      size: '@'
    });
  rater.link = function(scope, element, attr) {
    $(element).raterater({
      allowChange: false,
      isStatic: true,
      rating: scope.rateData,
      starWidth: 20,
      spaceWidth: 5
    });
  };
  return rater;
});
/** Common jQuery Rater, which is highly customizable **/
clickxApp.directive('commonRater', function() {
  var rater = {};
  (rater.restrict = 'AE'),
    (rater.scope = {
      rateData: '@rateData',
      size: '@size',
      element: '@element',
      step: '@step'
    });
  rater.link = function(scope, element, attr) {
    $(element).raterater({
      allowChange: true,
      starWidth: parseInt(scope.size) || 42,
      step: scope.step || false,
      submitFunction: 'submitFunction'
    });
    submitFunction = function(id, rating) {
      $(document)
        .find('#' + scope.element)
        .attr('value', rating);
    };
  };
  return rater;
});
clickxApp.directive('mask2', function() {
  var mask2 = {};
  (mask2.restrict = 'A'),
    (mask2.link = function(scope, element, link) {
      $(element).inputmask('hh:mm t', {
        placeholder: 'HH:MM xm',
        insertMode: false,
        showMaskOnHover: false,
        hourFormat: 12
        // mask: "hh:mm t\\m",
      });
    });
  return mask2;
});

/** Convert title to slug **/
clickxApp.directive('linkFromTitle', [
  '$rootScope',
  '$routeParams',
  function($rootScope, $routeParams) {
    return {
      restrict: 'EA',
      replace: true,
      scope: {
        title: '=',
        crawlSummary: '=',
        linkValue: '='
      },
      template:
        '<div><a ng-href="{{shouldShow? slug : \'javascript:void(0)\'}}" ng-disabled="!shouldShow" ng-if="shouldShow">{{title}}</a>' +
        '<span ng-if="!shouldShow">{{title}}</span></div>',
      link: function(scope, iElement, iAttrs) {
        scope.shouldShow = true;
        scope.$watch('linkValue', function(newValue, oldValue) {
          var newValue = newValue ? parseInt(newValue) : null;
          scope.shouldShow =
            $.isNumeric(newValue) && newValue == 0 ? false : true;
        });

        scope.$watch('crawlSummary', function(newV, oldV) {
          if (typeof newV != 'undefined') {
            try {
              var reportKey = scope.title.toLowerCase().replace(/\s+/g, '_');
              var slug = scope.crawlSummary[reportKey + '_report_id'];
              scope.slug =
                '#/' +
                $routeParams.business_id +
                '/site-audit/details' +
                '?report_id=' +
                slug +
                '&title=' +
                scope.title;
            } catch (er) {
              console.log(er);
            }
          }
        });
      }
    };
  }
]);

/** eof convert title to slug **/
/** eof breadcrumps **/
clickxApp.directive('stSummary', function() {
  return {
    restrict: 'AE',
    require: '^stTable',
    template:
      '<span>Showing {{pagination.start +1}} to {{pagination.to}} of {{pagination.total_pages}} items.</span>',
    scope: {},
    link: function(scope, element, attr, ctrl) {
      scope.$watch(
        ctrl.tableState(),
        function(newValue, oldValue) {
          scope.pagination = ctrl.tableState().pagination;
        },
        true
      );
    }
  };
});

/** Add Remove Keywords **/
clickxApp.directive('addRemoveKeywords', [
  '$rootScope',
  '$routeParams',
  '$route',
  'Business',
  function($rootScope, $routeParams, $route, Business) {
    var addTemplate =
      '<button href="javascript:void(0)" class="button btn m-n btn-raised btn-xs pull-right " ' +
      "ng-class=\"{'add-plus btn-inverse':addKeyword==false,'btn-danger':addKeyword==true}\">" +
      '<i class="fa" ng-class="{\'fa-plus\':addKeyword==false,\'fa-trash\':addKeyword==true}">' +
      '</i></button>';
    return {
      restrict: 'E',
      replace: true,
      template: addTemplate,
      scope: {
        keyword: '='
      },
      link: function(scope, element, attr) {
        scope.business_id = $routeParams.business_id || 27;
        scope.addKeyword = false;
        scope.$watch(
          'keyword',
          function(newValue, oldValue) {
            if (newValue && newValue.keyword_exist == true) {
              scope.addKeyword = newValue.keyword_exist;
            } else {
              scope.addKeyword = false;
            }
          },
          true
        );
        $(element).click(function() {
          if ($(this).hasClass('add-plus')) {
            // Add
            var keywordName =
              scope.keyword.name ||
              scope.keyword.query ||
              scope.keyword.keys ||
              scope.keyword.keyword;
            Business.add_to_keyword_bank(
              { id: scope.business_id },
              {
                keyword: [keywordName]
              },
              function(result) {
                //console.log(result)
                toastr.success('Keyword added sucessfully');
                scope.$emit('reloadListData');
              },
              function(error) {
                //console.log(error)
              }
            );
          } else {
            // Remove
            if (scope.keyword.keyword_id) {
              Business.delete_business_keyword(
                {
                  id: scope.business_id
                },
                {
                  keyword_ids: [scope.keyword.keyword_id]
                },
                function(result) {
                  toastr.warning('Keyword deleted successfully');
                  delete scope.keyword.keyword_exist; // remove current one
                  scope.$emit('reloadListData');
                },
                function(error) {
                  console.log(error);
                }
              );
            }
          }
        });
      }
    };
  }
]);

/* Slim Scroll */
clickxApp.directive('slimScroll', [
  function() {
    return {
      restrict: 'EA',
      scope: {
        options: '=',
        slimScroll: '='
      },
      link: function(scope, element, attr) {
        var options = scope.slimScroll || {};
        $(element).slimScroll(options);
      }
    };
  }
]);

/** eof **/

clickxApp.directive('resetColspan', [
  '$timeout',
  function($timeout) {
    return {
      restrict: 'A',
      transclude: true,
      replace: true,
      template: '<ng-transclude></ng-transclude>',
      link: function(scope, element, attr, ctrl, transcludeFn) {
        // detect when checkbox clicked
        _setColSpanTable(300);
        $(element)
          .find('.column-select-menu')
          .on('click', '.column-selector', function() {
            _setColSpanTable(0);
          });

        function _setColSpanTable(timeout) {
          $timeout(function() {
            // Heading
            var numberOfColumns = $(element)
              .find('table')
              .find('tr.heading-tr')
              .find('th').length;
            var searchElement = $(element).find('.search-bar');
            var searchColRation = JSON.parse(searchElement.attr('ratio'));
            var tempRationTotal = 0;
            _.each(searchColRation.ration, function(value, index) {
              var colspan = Math.round(
                (value * numberOfColumns) / searchColRation.total
              );
              if (searchColRation.ration.length - 1 == index) {
                colspan = numberOfColumns - tempRationTotal;
              } else {
                tempRationTotal += colspan;
              }
              searchElement
                .find('th:nth-child(' + (index + 1) + ')')
                .attr('colspan', colspan);
            });

            // TFOOT
            $(element)
              .find('.lead-pagination')
              .attr('colspan', numberOfColumns);
          }, timeout);
        }
      }
    };
  }
]);

/**
 * @description Show full screen modal, update slimscroll based on available height
 */
clickxApp.directive('dynamicSlimscroll', [
  '$timeout',
  '$window',
  function($timeout, $window) {
    return {
      restrict: 'EAC',
      replace: true,
      transclude: true,
      template: '<div class="panel-body"><ng-transclude></ng-transclude></div>',
      link: function(scope, ele, attr) {
        /**
         *
         * @return {number}
         * @private
         */
        function __findHeightAfterChange() {
          var closestModal = $('.clx-full-screen-modal');
          var modalHeight = closestModal.height();
          var modalDialogAction = closestModal
            .find('md-dialog-actions')
            .height();
          var keywordEnterForm = closestModal
            .find('.keyword-enter-form')
            .height();
          var requireHeight =
            modalHeight - (63 + modalDialogAction + keywordEnterForm + 200);
          return requireHeight > 140 ? requireHeight : 140;
        }

        var adjustHeight = __findHeightAfterChange();
        scope.slimObject = {
          height: adjustHeight,
          noWatch: false
        };

        $timeout(function() {
          __heightAdjustMent();
        }, 100);
        angular.element($window).bind('resize', function() {
          __heightAdjustMent();
        });

        function __heightAdjustMent() {
          var textField = angular.element('#keyword-form-text');
          adjustHeight = __findHeightAfterChange();
          scope.slimObject['height'] = adjustHeight;
          textField.css({ height: adjustHeight + 135 });
          if (!scope.$$phase) {
            scope.$apply();
          }
        }
      }
    };
  }
]);
