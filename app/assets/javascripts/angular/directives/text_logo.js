clickxApp.directive('textLogo', [
  '$filter',
  function($filter) {
    return {
      restrict: 'E',
      link: function(scope, element, attrs) {
        var style = angular.fromJson(attrs.style);
        var logoText = function(text) {
          var logo_text = _.map(
            text
              .trim()
              .replace(/  +/g, ' ')
              .split(/[ -]+/),
            function(word) {
              return _.first(word).toUpperCase();
            }
          )
            .join('')
            .replace(/\W/g, '');
          return logo_text.length === 1
            ? logo_text + text[1].toUpperCase()
            : logo_text;
        };
        var htmlText, logo_text, x_property;
        if (attrs.logo && attrs.logo != 'null') {
          htmlText =
            '<img class="default-logo-style" src=' + attrs.logo +
            ' style = "max-height: ' + style.hlogo + 'px;">';
        } else if (attrs.subtext) {
          logo_text = $filter('limitTo')(logoText(attrs.subtext), 2);
          htmlText =
            ' <svg height="' +
            style.height +
            '" width="' +
            style.width +
            '" style="display: table;float:left;"> ' +
            ' <circle cx="' +
            style.cx +
            '" cy="' +
            style.cy +
            '" fill="#F8B018" r="' +
            style.r +
            '"></circle> ' +
            ' <text fill="white" font-family="Verdana" font-size="' +
            style.font_size +
            '" ' +
            ' y="' +
            style.y +
            '" x="' +
            style.x +
            '"> ' +
            logo_text +
            '</text></svg>';
        }
        element.replaceWith(htmlText);
      }
    };
  }
]);
