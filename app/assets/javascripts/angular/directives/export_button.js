/*
=============================================
=    Example  Download  Button  Dropdown    =
=============================================
Refer `leads_controller.js` and `lead.html.haml`

  In View:
    %export-button{ 'pdf': 'true', 'csv': 'true', 'csv-all': 'true' }

  In Controller:
    $scope.pdf_export = function(){
      html2canvas($('#exportPDF'), {
        onrendered: function(canvas){
          var data = canvas.toDataURL();
          var docDefinition = {
            content: [{
              image: data,
              width: 500
            }]
          };
          pdfMake.createPdf(docDefinition).download('contacts.pdf');
        }
      });
    };

    $scope.csv_url = "/businesses/" + $scope.business_id + "/tracker_contacts.csv?" + jQuery.param(params);

    $scope.csv_all_url = "/businesses/" + $scope.business_id + "/tracker_contacts.csv";

==================Example=================
*/

clickxApp.directive('exportButton', [
  '$compile',
  function($compile) {
    return {
      restrict: 'E',
      replace: true,
      link: function(scope, element, attrs) {
        var pdfExport,
          csvExport,
          csvAllExport,
          htmlHeader,
          htmlFooter,
          htmlElement;
        var showElement = attrs.pdf || attrs.csv || attrs.csvAll;
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
          ? '<li class="p-sm"><a ng-click="pdf_export()">PDF</a></li>'
          : '';
        pdfExport = attrs.pdf && attrs.name
          ? "<li class='p-sm'><a ng-click=\"pdf_export('" + attrs.name + "')\">PDF</a></li>"
          : pdfExport;
        csvExport = attrs.csv
          ? '<li class="p-sm"><' +
            'a ng-href="{{csv_url}}" target="_blank">CSV</a></li>'
          : '';
        csvAllExport = attrs.csvAll
          ? '<li class="p-sm"><' +
            'a ng-href="{{csv_all_url}}" target="_blank">CSV - ALL</a></li>'
          : '';

        htmlElement = $compile(
          htmlHeader + pdfExport + csvExport + csvAllExport + htmlFooter
        )(scope);
        element.replaceWith(htmlElement);
      }
    };
  }
]);
