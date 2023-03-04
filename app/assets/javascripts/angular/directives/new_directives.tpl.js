/**
 * Created by sibin on 27/10/16.
 */
clickxApp.directive('rpCollapsePanel', [
  function() {
    var rpCollapseObject = {};
    rpCollapseObject.restrict = 'EAC';
    rpCollapseObject.transclude = true;
    rpCollapseObject.scope = {};
    rpCollapseObject.link = function(scope, element, attr, ctrl, transcludeFn) {
      var parentElementToCollapse = $(attr.rpCollapsePanel);
      transcludeFn(scope.$parent.$new(), function(content) {
        element.append(content);
      });

      $(element)
        .find('.open-collapse')
        .parent('.panel-heading')
        .on('click', function() {
          $(parentElementToCollapse)
            .find('.panel')
            .children('.panel-body')
            .removeClass('in');
          $(parentElementToCollapse)
            .find('.panel')
            .children('.panel-heading')
            .find('.open-collapse')
            .removeClass('fa-chevron-up')
            .addClass('fa-chevron-down');
          if (
            !$(this)
              .find('.open-collapse')
              .hasClass('opened')
          ) {
            $(element)
              .find('.panel-body')
              .addClass('in');
            $(this)
              .find('.open-collapse')
              .removeClass('fa-chevron-down')
              .addClass('fa-chevron-up opened');
          } else {
            $(element)
              .find('.panel-body')
              .removeClass('in');
            $(this)
              .find('.open-collapse')
              .addClass('fa-chevron-down')
              .removeClass('fa-chevron-up opened');
          }
        });
    };
    rpCollapseObject.replace = true;
    return rpCollapseObject;
  }
]);
