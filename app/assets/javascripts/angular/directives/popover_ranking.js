clickxApp.directive('popoverSeo', function() {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      keyword: '=',
      type: '='
    },
    template: function(element, attrs) {
      if (attrs.type == 'google') {
        return (
          '<ul class="padding-zero">' +
          '<li><span><i class="glyphicon glyphicon-time"></i> Last checked {{keyword.lastGoogleRankingDate | fromnow}}</span></li>' +
          '<li ng-show="{{keyword.googleRankingUrl!=null}}"><span>' +
          '<i class="glyphicon glyphicon-list-alt"></i> Page </span><div class="pull-right">' +
          '<a href= "{{keyword.googleRankingUrl}}" target="_blank"> {{keyword.googleRankingUrl | seoLinkUrl}}' +
          '</a> </div></li><li ng-show="{{keyword.googleSerpUrl!=null}}">' +
          '<span><i class="glyphicon glyphicon-ok"></i> Verification' +
          '<a href= "{{keyword.googleSerpUrl}}" target="_blank"> SERP</a></span></li></ul>'
        );
      }
    }
  };
});

/*
 *   Create a custom directive called popoverTemplateA, add tooltip and popover js (from bootstrap),
 *   Using normal jquery open and close popovers, inorder to fetch content of a directive
 *   $templateCache and $compile used, fetched the data first and compiled it
 *   Then use ordinary popover options
 */
clickxApp.directive('popoverTemplateA', [
  '$templateCache',
  '$compile',
  function($templateCache, $compile) {
    var directiveA = {};
    directiveA.restrict = 'A';
    directiveA.link = function(scope, element, attr) {
      var htmlElement = $templateCache.get(attr.popoverTemplateA);
      var htmlElementHTML = $compile(htmlElement)(scope);
      var popoverSettings = {
        content: htmlElementHTML,
        html: true,
        placement: attr.popoverPlacement != '' ? attr.popoverPlacement : 'top',
        title: typeof attr.popoverTitle != 'undefined' ? attr.popoverTitle : ''
      };
      if (attr.popoverClassname) {
        var classNames = attr.popoverClassname;
        popoverSettings['template'] =
          '<div class="popover ' +
          classNames +
          '" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>';
      }

      $(element).popover(popoverSettings);

      $(element).on('mouseenter', function() {
        $(element).popover('show');
      });
      $(element)
        .parent()
        .on('mouseleave', function() {
          $(element).popover('hide');
        });
    };
    return directiveA;
  }
]);

/**
 * @description Replacement for Angular UI Bootstrap Popover,
 * Popover bootstrap support click|focus|manual|mouseover to trigger popup
 *
 *
 *
 */

clickxApp.directive('popoverTemplate', [
  '$templateCache',
  '$compile',
  '$templateRequest',
  function($templateCache, $compile, $templateRequest) {
    var popoverDirective = {};
    popoverDirective.restrict = 'EAC';
    popoverDirective.link = function(scope, ele, attr) {
      scope.title = 'This is a Wind';
      var element = $(ele);
      var _settings = {
        placement: 'bottom',
        animation: true,
        html: false,
        trigger: 'manual'
      };

      /** DEFAULTS **/
      var _triggers = {
        mouseenter: 'mouseleave',
        click: 'click',
        focus: 'blur',
        outsideClick: 'outsideClick'
      };
      var popoverTriggerIn = 'mouseenter';
      var popoverTriggerOut = 'mouseleave';

      /** END DEFAULTS **/

      if (
        typeof attr.popoverTrigger !== 'undefined' &&
        attr.popoverTrigger !== ''
      ) {
        var _userTrigger = attr.popoverTrigger;
        if (typeof _triggers[_userTrigger] !== 'undefined') {
          popoverTriggerIn = _userTrigger;
          popoverTriggerOut = _triggers[_userTrigger];
        }
      }

      if (attr.popoverTitle !== undefined) {
        _settings['title'] = attr.popoverTitle;
      }
      if (attr.popoverPlacement !== undefined) {
        _settings['placement'] = attr.popoverPlacement;
      }
      var templateURL = attr.popoverTemplate;
      if (templateURL !== undefined) {
        templateURL = templateURL.replace(/\'/g, '');
        /**
         * @description templateRequest will find template from url or ng-template
         * if it fail it will check $templateCache (When user add script with ng-template, it will save)
         * inside templateCache. Trying both actual url and script ng-template
         * @todo Repeated code can be make one
         */
        $templateRequest(templateURL, true)
          .then(
            function(response) {
              var templateEle = $compile(response)(scope);
              if (templateEle) {
                _settings['html'] = true;
                _settings['content'] = templateEle;
              }
            },
            function(error) {
              if (error.status === 404) {
                var htmlElement = $templateCache.get(templateURL);
                var htmlElementHTML = $compile(htmlElement)(scope);
                if (htmlElementHTML) {
                  _settings['html'] = true;
                  _settings['content'] = htmlElementHTML;
                }
              }
            }
          )
          .finally(function() {
            element.popover(_settings);
          });
      }

      /** CUSTOMIZATION **/
      var customClass = attr.popoverClassname;
      if (customClass !== undefined && customClass !== '') {
        popoverSettings['template'] =
          '<div class="popover ' +
          customClass +
          '" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>';
      }

      /** END CUSTOMIZATON **/

      /** EVENTS **/
      /* IN */
      var $triggerEle = $(element);
      if (popoverTriggerIn !== 'click' && popoverTriggerOut !== 'click') {
        if (popoverTriggerIn === 'outsideClick') {
          popoverTriggerIn = 'click';
        }
        $triggerEle.on(popoverTriggerIn, function() {
          $(element).popover('show');
        });
        if (popoverTriggerOut === 'mouseleave') {
          $triggerEle = $(element).parent();
        }
        if (popoverTriggerOut === 'outsideClick') {
          popoverTriggerOut = 'click';
          $triggerEle = $('body');
          $(element).on('click', function(e) {
            e.stopPropagation();
          });
          $(element)
            .parent()
            .on('click', '.popover', function(e) {
              e.stopPropagation();
            });
        }
        $triggerEle.on(popoverTriggerOut, function(e) {
          e.preventDefault();
          $(element).popover('hide');
        });
      } else {
        $(element).on(popoverTriggerIn, function(e) {
          e.preventDefault();
          $(element).popover('toggle');
          e.stopPropagation();
        });
      }

      /** END EVENTS **/
    };

    return popoverDirective;
  }
]);
