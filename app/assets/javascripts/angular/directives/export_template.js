clickxApp.directive('exportTemplate', [
  '$compile',
  function($compile) {
    return {
      restrict: 'E',
      replace: true,
      link: function(scope, element, attrs) {
        var pdfExport,
          pdfExportAll,
          csvExport,
          csvAllExport,
          htmlHeader,
          htmlFooter,
          htmlElement;
        var showElement =
          attrs.pdf || attrs.csv || attrs.csvAll || attrs.pdfAll;
        var css_class = 'btn btn-white bg-white ';
        if (!attrs.btnRaise) css_class += 'btn-raised';
        htmlHeader =
          '<div ng-show="' +
          showElement +
          '" class="btn-group dropdown m-n">' +
          '<md-button class=" ' +
          css_class +
          '" href=""' +
          'style="width:135px;" data-toggle="dropdown" aria-expanded="false">' +
          '<i class="fa fa-download pr-xs"></i>Export' +
          '<span class="caret ml-lg"></span>' +
          '<div class="ripple-container"></div></md-button>' +
          '<ul class="dropdown-menu export-drop-down btn-block" role="menu">';

        htmlFooter = '</ul></div>';

        pdfExport = attrs.pdf
          ? '<li class="p-sm"><' +
            'a ng-href="{{export_pdf}}" target="_blank">PDF</a></li>'
          : '';
        pdfExportAll = attrs.pdfAll
          ? '<li class="p-sm"><' +
            'a ng-href="{{export_pdf_all}}" target="_blank">PDF - All</a></li>'
          : '';
        csvExport = attrs.csv
          ? '<li class="p-sm"><' +
            'a ng-href="{{csv_url}}" target="_blank">CSV</a></li>'
          : '';
        csvAllExport = attrs.csvAll
          ? '<li class="p-sm"><' +
            'a ng-href="{{csv_all_url}}" target="_blank">CSV - ALL</a></li>'
          : '';

        htmlElement = $compile(
          htmlHeader +
            pdfExport +
            pdfExportAll +
            csvExport +
            csvAllExport +
            htmlFooter
        )(scope);
        element.replaceWith(htmlElement);
      }
    };
  }
]);
