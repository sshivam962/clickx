clickxApp.controller('viewKeywords', [
  '$scope',
  '$rootScope',
  'Business',
  '$timeout',
  'SeoKeywordsChart',
  '$mdDialog',
  '$window',
  '$document',
  'SiteAuditService',
  function (
    $scope,
    $rootScope,
    Business,
    $timeout,
    SeoKeywordsChart,
    $mdDialog,
    $window,
    $document,
    SiteAuditService
  ) {
    $scope.business_id = current_business;
    $scope.csv_all_url =
      '/businesses/' + $rootScope.current_business + '/export_kr_to_csv';
    $rootScope.hide_google = $rootScope.hide_google || false;
    $rootScope.hide_search_volume = $rootScope.hide_search_volume || false;
    $rootScope.hide_cpc = $rootScope.hide_cpc || false;
    $rootScope.hide_keywords = $rootScope.hide_keywords || false;
    $rootScope.hide_kdi = $rootScope.hide_kdi || false;
    $rootScope.limit_keyword_rows = $rootScope.limit_keyword_rows || 50;

    /* For Smart Table pagination */
    $rootScope.keywords = [];
    $scope.tag = [];
    $scope.location = [];
    $scope.paginationStart = 0;
    $scope.loadingTable = false;

    $scope.competitorRankList = function (name, id) {
      Business.competitor_ranks({ id: id, name: name }, function(response) {
        if (response.status == 200) {
          competitor_ranks = response.competitor_ranks
          $mdDialog.show({
            templateUrl: 'themeX/snippets/_competitors_rank.html',
            locals: {
              competitor_ranks: competitor_ranks
            },
            controller: [
              '$scope',
              '$mdDialog',
              'competitor_ranks',
              function ($scope, $mdDialog, competitor_ranks) {
                $scope.closeModal = function (e) {
                  $mdDialog.cancel('close');
                };
                $scope.competitor_ranks = competitor_ranks;
              }
            ]
          });
        }
      });
    };

    $scope.keywordEditModal = function (keyword) {
      $mdDialog.show({
        templateUrl: 'edit-keyword.html',
        locals: {
          keyword: keyword
        },
        controller: 'EditKeyword'
      });
    };

    $scope.gotoSiteAudit = function ($event, uri) {
      SiteAuditService.page_error(
        {
          id: $scope.business_id,
          url: uri
        },
        function (result) {
          $window.localStorage.setItem($scope.business_id, angular.toJson(uri));
          $window.location.href =
            '/#/' + $scope.business_id + '/page_analytics';
        },
        function (error) {
          var html =
            "<tr class='error-append-msg'>" +
            "<td colspan = '9'>" +
            "<div class='alert alert-warning alert-dismissable fade in'>" +
            "<a class='close'>×</a>" +
            "<p class='text-center'>" +
            error.data.error +
            '</p>' +
            '  </div>' +
            '</td>' +
            '</tr>';
          $('.error-append-msg').remove();
          $(html).insertAfter(
            $($event.currentTarget)
              .parent()
              .parent()
          );

          var timer = setTimeout(function () {
            $('.error-append-msg').fadeOut();
          }, 3000);

          $('.close').click(function () {
            $('.error-append-msg').remove();
          });

          $('.error-append-msg').hover(
            function () {
              clearTimeout(timer);
            },
            function () {
              $('.error-append-msg').fadeOut();
            }
          );
        }
      );
    };

    $scope.getTags = function () {
      Business.all_keyword_tags(
        {
          id: $scope.business_id
        },
        function (result) {
          $scope.all_tags = result.businesses_keyword_tags;
        },
        function (error) { }
      );
    }();

    $scope.getKeywordLocations = function () {
      Business.keyword_locations(
        {
          id: $scope.business_id
        },
        function (result) {
          $scope.locations = result.keyword_locations;
        },
        function (error) { }
      );
    }();

    $scope.openAddKeyword = function () {
      $mdDialog
        .show({
          controller: 'AddKeyword',
          templateUrl: 'themeX/keywords/_add_keyword.html',
          locals: {
            data: { possibilities: [], tags: $scope.all_tags },
            business: $scope.business
          }
        })
        .then(
          function (status) {
            if (status && status === 'success') {
              $rootScope.fetchKeywordRanking($scope.filterData);
              $scope.appendWishlistKeyword();
            }
          },
          function (cancel) { }
        );
    };

    /** Page Size
     * A3: [841.90, 1190.60 ]
     * A4: [595.30, 841.90]
     * A2: [1190.60, 1682.80]
     */
    var pdfPageSize = {
      A3: [841.9, 1190.6],
      A4: [595.3, 841.9],
      A2: [1190.6, 1683.8],
      A1: [1683.8, 2384],
      B1: [1000.6, 1417.3],
      B2: [1417.3, 2004.1]
    };

    /* Method One */
    var ids = ['#graph_export', '#table_export'];
    var i = 0;
    var docDefinition = {
      pageSize: 'A4',
      content: [],
      style: {
        alignment: 'center'
      }
    };

    /**
     * @name PDF Download Method 2
     * @see https://github.com/bpampuch/pdfmake/wiki/Custom-Fonts---client-side
     */
    var fontAwesomeFonts = {
      'fa-caret-up': '',
      'fa-caret-down': '',
      'fa-chevron-up': '',
      'fa-chevron-down': ''
    };
    var pageSizeSelect = 'A4';
    var pdfDocument = {
      content: []
    };
    pdfDocument = _.extend($rootScope.pdfMakeConfig, pdfDocument); // extend with default settings

    /* Trigger Event */
    $scope.pdf_export = function () {
      pdfDocument.content = [];
      var chartElement = $(document)
        .find('#graph_export')
        .filter(':visible');
      var keywordTable = $(document)
        .find('#table_export')
        .find('table');
      /* Call Table First, Then Call Chart */
      call_table_function();
      /**
       * @description Function to create PDF from chart
       * Convert canvas to image, then to PDF
       */
      function call_chart_function() {
        /** Chart Section **/
        html2canvas(chartElement, {}).then(function(canvas) {
          var image = canvas.toDataURL();
          pdfDocument.content.unshift({
            image: image,
            fit: _.map(pdfPageSize[pageSizeSelect], function (item) {
              return item - 80;
            }),
            margin: [0, 0, 0, 20]
          });
          createPDFFromDoc(pdfDocument);
        });
      }
      /** End Chart Section **/
      /** Table **/
      function call_table_function() {
        // Get Header and Body of Table
        var tableHeaders = [];
        var tableHeadTrs = keywordTable.find('thead').find('tr');
        var firstTableHead = tableHeadTrs
          .eq(0)
          .find('th')
          .filter(':visible');
        var secondTableHead = tableHeadTrs
          .eq(1)
          .find('th')
          .filter(':visible');
        var tableThFirst = [],
          tableThSecond = [];
        var secondTableIndex = 0;
        var widthCalculation = [];
        firstTableHead.each(function (index, item) {
          var td = {},
            td2 = {},
            secondTableEle,
            colSpan,
            rowSpan,
            width = 'auto';
          var ele = $(item);
          if (index === firstTableHead.length - 1) return;
          if (
            ((rowSpan = parseInt(ele.attr('rowSpan'))), ele.attr('rowSpan'))
          ) {
            td['text'] = ele.text().trim();
            td['style'] = ['headerOne', 'noBorder', 'rowHeader'];
            td['border'] = [false, false, false, false];
            td['rowSpan'] = rowSpan;
            tableThFirst.push(td);
            tableThSecond.push('');
            if (ele.text().trim() === 'Keywords') width = '*';
            widthCalculation.push(width);
          }
          if (
            ((colSpan = parseInt(ele.attr('colSpan'))), ele.attr('colSpan'))
          ) {
            for (var i = 0; i < colSpan; i++) {
              if (i === 0) {
                td['text'] = ele.text().trim();
                td['style'] = ['headerOne', 'centerText', 'noBorder'];
                td['border'] = [false, false, false, false];
                td['colSpan'] = colSpan;
                widthCalculation.push(30);
              } else {
                td = '';
                if (i === 1) {
                  widthCalculation.push(40);
                } else {
                  widthCalculation.push(width);
                }
              }
              tableThFirst.push(td);
              if (angular.isDefined(secondTableHead)) {
                secondTableEle = $(secondTableHead[secondTableIndex]);
                td2 = {
                  text: secondTableEle.text().trim(),
                  style: ['secondTrStyle']
                };
                tableThSecond.push(td2);
                secondTableIndex++;
              } else {
                tableThSecond.push('');
              }
            }
          }
          if (!ele.attr('colSpan') && !ele.attr('rowSpan')) {
            td['text'] = ele.text().trim();
            td['style'] = ['headerOne', 'noBorder'];
            td['border'] = [false, false, false, false];
            tableThFirst.push(td);
            if (angular.isDefined(secondTableHead)) {
              secondTableEle = $(secondTableHead[secondTableIndex]);
              td2 = {
                text: secondTableEle.text().trim(),
                style: ['secondTrStyle']
              };
              secondTableIndex += 1;
              tableThSecond.push(td2);
            } else {
              tableThSecond.push('');
            }
            if (ele.text().trim() === 'Keywords') width = '*';
            widthCalculation.push(width);
          }
        });
        // Body Section
        var bodyTR = [];
        keywordTable
          .find('tbody')
          .eq(0)
          .find('tr')
          .filter(':visible')
          .each(function (index, tr) {
            var tds = [];
            $(tr)
              .find('td')
              .filter(':visible')
              .each(function (index, td) {
                // Keyword
                if (index === $(tr).children().length - 1) return;
                var fontIconEle = $(td).find('.fa');
                var superSet = $(td).find('sup');
                var text_array = [];
                if ($(td).children().length > 0) {
                  $.each(
                    $(td)
                      .children()
                      .filter(':visible'),
                    function (i, v) {
                      if ($(v).find('.keyword_name')[0]) {
                        child_array = $(v)
                          .find('.keyword_name')
                          .children()
                          .first()
                          .text()
                          .trim()
                          .split('\n')
                          .filter(function (v) {
                            return v !== '';
                          })
                          .join('\n');
                      } else {
                        child_array = $(v)
                          .text()
                          .trim()
                          .split('\n')
                          .filter(function (v) {
                            return v !== '';
                          })
                          .join('\n');
                      }
                      text_array.push(child_array);
                    }
                  );
                  text_array = text_array.filter(function (v) {
                    return v !== '';
                  });
                }
                var textContent = text_array.join('\n');
                if (fontIconEle.length > 0) {
                  // font icons
                  var fontClass = fontIconEle.get(0).classList[1],
                    changeColor = '',
                    iconImage = '',
                    marginTop = 0;
                  switch (fontClass) {
                    case 'fa-caret-up':
                    case 'fa-chevron-up':
                      changeColor = ['success', 'upArrow'];
                      iconImage = 'caretUp';
                      marginTop = 2;
                      break;
                    case 'fa-caret-down':
                    case 'fa-chevron-down':
                      changeColor = ['danger', 'downArrow'];
                      iconImage = 'caretDown';
                      marginTop = 3;
                      break;
                  }
                  if (changeColor) {
                    tds.push({
                      columns: [
                        {
                          width: 5,
                          marginTop: marginTop,
                          image: iconImage
                        },
                        {
                          width: '*',
                          marginLeft: 3,
                          text: textContent,
                          style: [changeColor]
                        }
                      ]
                    });
                  } else {
                    tds.push({
                      text: [
                        {
                          text: textContent,
                          style: [changeColor]
                        }
                      ]
                    });
                  }
                } else if (superSet.length > 0) {
                  // number
                  tds.push({
                    text: [
                      {
                        text: textContent.match(/[0-9]+/)[0] || '',
                        style: ['supText']
                      },
                      {
                        text: superSet.text(),
                        style: ['superset']
                      }
                    ]
                  });
                } else {
                  var htmlMake = document.createElement('div');
                  htmlMake.innerHTML = textContent;
                  textContent =
                    htmlMake.textContent || htmlMake.innerText || '';
                  textContent = textContent.trim() || '';
                  // textContent =
                  tds.push({
                    text: [
                      {
                        text: textContent
                      }
                    ]
                  });
                }
              });
            bodyTR.push(tds);
          });

        /* All Header */
        var allHeader = [];
        allHeader = [tableThFirst, tableThSecond];
        _.each(bodyTR, function (item) {
          allHeader.push(item);
        });
        pdfDocument.content.push({
          table: {
            widths: widthCalculation,
            headerRows: 2,
            body: allHeader
          },
          layout: {
            paddingLeft: function (i, node) {
              return 10;
            },
            paddingRight: function (i, node) {
              return 10;
            },
            paddingTop: function (i, node) {
              return 5;
            },
            paddingBottom: function (i, node) {
              return 5;
            },
            fillColor: function (i, node) {
              if (i < 2) {
                return '#cccccc';
              }
              return i % 2 === 0 ? '#fff' : '#eeeeee';
            },
            hLineColor: function (i, node) {
              return '#eee';
            },
            vLineColor: function (i, node) {
              return '#eee';
            }
          }
        });
        /* Call Chart to PDF */
        call_chart_function();
      }
      /** End Table Data **/

      /**
       * Create PDF from JSON document
       * @param pdfDocument
       */
      function createPDFFromDoc(pdfDocument) {
        var keywordFileName =
          'keyword-download-' + moment().format('DD-MM-YYYY-hh-mm-ss') + '.pdf';
        pdfMake.createPdf(pdfDocument).download(keywordFileName);
      }
    };
    /** PDF Download 2*/

    /* This will set color globally, If you want to use same color every where use this */
    /*
          Highcharts.setOptions({
          colors: ["#378529","#7cb23f","#ffd02b","#ff7b27","#e3483d","#888888"]
        });
        */
    /* HighChart - Google keywords */
    $scope.appendWishlistKeyword = function () {
      Business.wishlist_keywords(
        {
          id: $scope.business_id
        },
        function (result) {
          $scope.wishlist = result.keywords;
        },
        function (error) { }
      );
    };

    $rootScope.setData = function () {
      $rootScope.keywordResult.$promise.then(function (result) {
        var csv_params = {};
        csv_params['limit'] = $scope.filterData.limit;
        csv_params['offset'] = $scope.filterData.offset;
        $scope.csv_url =
          '/businesses/' +
          current_business +
          '/export_kr_to_csv?' +
          jQuery.param(csv_params);
        $rootScope.keywords = result.data || [];
        $rootScope.all_keywords = $rootScope.keywords;
        $scope.tableState.pagination['to'] = Math.min(
          $scope.tableState.pagination.start +
          $scope.tableState.pagination.number,
          result.total_size || 0
        );
        $scope.paginationStart = $scope.tableState.pagination.start || 0;
        $scope.tableState.pagination.total_pages = result.total_size || 0;
        $scope.tableState.pagination.numberOfPages = Math.ceil(
          result.total_size / $scope.filterData.limit
        );
        $('#select_keywords').prop('checked', false);
        $scope.show_delete_btn = false;
        $scope.loadingTable = false;
      });
      $scope.appendWishlistKeyword();
    };
    try {
      $rootScope.timespan = $rootScope.timespan || 'all_time';
      $scope.filterData = {
        id: $scope.business_id,
        time_string: $rootScope.timespan
      };

      $scope.stTableServer = function (tableState, ctrl) {
        $scope.loadingTable = true;
        $scope.stCtrl = ctrl;
        $scope.tableState = tableState;
        var pagination = tableState.pagination;
        $scope.filterData['offset'] = pagination.start || 0;
        $scope.filterData['limit'] = pagination.number || 50;
        $rootScope.limit_keyword_rows = pagination.number;
        try {
          $scope.filterData['search'] = tableState.search.predicateObject.name;
        } catch (error) {
          delete $scope.filterData['search'];
        }
        try {
          $scope.filterData['tag_ids'] = angular.toJson(_.pluck($scope.tag, 'id'));
        } catch (error) {
          delete $scope.filterData['tag_ids'];
        }
        try {
          $scope.filterData['location'] = angular.toJson($scope.location);
        } catch (error) {
          delete $scope.filterData['location'];
        }
        if (tableState.sort && tableState.sort.predicate) {
          $scope.filterData['sort'] = tableState.sort.predicate;
          $scope.filterData['sort_order'] = tableState.sort.reverse;
        } else {
          // delete property if their neutral sort and sort_order
          delete $scope.filterData['sort'];
          delete $scope.filterData['sort_order'];
        }

        $scope.export_pdf =
          '/businesses/' +
          $scope.business_id +
          '/keyword_ranking_exports.pdf?' +
          jQuery.param($scope.filterData);

        if (
          tableState.pagination.total_pages ||
          tableState.pagination.total_pages == 0
        ) {
          $rootScope.fetchKeywordRanking($scope.filterData);
        } else {
          $timeout(function () {
            $rootScope.setData();
          });
        }
      };

      $rootScope.$watch(
        function () {
          return $rootScope.keywordResult;
        },
        function (newValue, oldValue) {
          if (newValue !== oldValue) {
            $rootScope.setData();
          }
        }
      );

      $rootScope.setChartData = function (result) {
        $scope.keywordRowData = result.row;
        var processedData = SeoKeywordsChart.processKeyWordData(
          result,
          $rootScope.timespan
        );
        try {
          $scope.keyWordChartOptions = SeoKeywordsChart.getKeyWordDataChart(
            processedData.allKeywordsDate,
            processedData.searchEngineData,
            false,
            $rootScope.timespan
          );
          $timeout(function () {
            callGoogleKeywordChart($scope.keyWordChartOptions[0]);
            $scope.googleKChart = $('#all-time-keywords-google').highcharts();
          }, 500);
        } catch (e) {
          var message = e.message;
          $('#all-time-keywords')
            .addClass('alert alert-danger')
            .html('Unknown Errors. ' + message);
        }
      };

      $rootScope.keywordChartResult.$promise.then(function (result) {
        $rootScope.setChartData(result);
      });

      $scope.filterTable = function () {
        $scope.stCtrl.pipe($scope.stCtrl.tableState());
      };

      $rootScope.searchEngine = 'google';
      $scope.history_url = function (id) {
        return '/#/' + $scope.business_id + '/keyword_history/' + id;
      };
      $rootScope.showModal = function (date_clicked, range, timespan, ev) {
        var params = {};
        if (timespan === 'all_time') {
          params.rankDuration = 'month';
        } else {
          params.rankDuration = 'day';
        }
        params.rankDate = moment(date_clicked, "D MMM 'YY").format(
          'YYYY-MM-DD'
        );
        if (moment(params.rankDate).isAfter()) {
          params.rankDate = moment(date_clicked, 'MMM D')
            .subtract(1, 'year')
            .format('YYYY-MM-DD');
        }
        params.rankRange = range;
        $mdDialog.show({
          controller: 'RankSummary',
          templateUrl: 'rank_summary',
          locals: {
            params: params
          },
          parent: angular.element($document.body),
          targetEvent: ev,
          clickOutsideToClose: false,
          fullscreen: false
        });
      };
      /** Change Time span and Update code **/
      $scope.changeTimeSpan = function (timespan) {
        $rootScope.timespan = timespan;
        $scope.filterData = {
          id: $scope.business_id,
          time_string: $rootScope.timespan,
          offset: 0,
          limit: $rootScope.limit_keyword_rows,
          sort: 'google_ranking_change',
          sort_order: 'false'
        };
        // reset search when time change
        if ($scope.filterData.search) {
          delete $scope.filterData.search;
        }

        $rootScope.fetchKeywordRanking($scope.filterData);

        Business.get_datewise_rankings(
          {
            id: $scope.business_id,
            date_string: $rootScope.timespan
          },
          function (result) {
            $rootScope.setChartData(result);
          }
        );
      };
    } catch (hdchart) { }

    var deleteKeywords = [];
    /* Delete single keyword */
    $scope.deleteKeyword = function (keywordId) {
      deleteKeywords.push(keywordId);
      Business.delete_business_keyword(
        {
          id: $scope.business_id
        },
        {
          keyword_ids: deleteKeywords
        },
        function (result) {
          deleteKeywords = [];
          $rootScope.fetchKeywordRanking($scope.filterData);
        },
        function (error) {
          deleteKeywords = [];
        }
      );
    };

    toggleKeywords = function (value) {
      $rootScope.keywords = _.map($rootScope.keywords, function (keyword) {
        keyword['checked'] = value;
        return keyword;
      });
    };
    /* Select bulk keywords */
    $scope.show_delete_btn = false;
    $scope.toggleKeywordSelect = function (event) {
      if (event.target.checked) {
        toggleKeywords(true);
        $('.keyword-checkbox').prop('checked', true);
        $scope.show_delete_btn = true;
      } else {
        toggleKeywords(false);
        $('.keyword-checkbox').prop('checked', false);
        $scope.show_delete_btn = false;
      }
    };

    $scope.singleCheckboxAction = function (e) {
      if (e.target.checked) {
        $scope.show_delete_btn = true;
      } else {
        $scope.show_delete_btn =
          $('.keyword-checkbox:checked').length > 0 ? true : false;
      }
    };
    /* Delete selected keywords */
    $scope.deleteSelectedKeyword = function (event) {
      deleteKeywords = [];
      $('.keyword-checkbox:checked').each(function (index, element) {
        deleteKeywords.push($(element).val());
      });

      if (deleteKeywords.length === 0) {
        toastr.info('Please select any keywords to delete');
        return;
      }

      Business.delete_business_keyword(
        {
          id: $scope.business_id
        },
        {
          keyword_ids: deleteKeywords
        },
        function (result) {
          deleteKeywords = [];
          $rootScope.fetchKeywordRanking($scope.filterData);
          toastr.success('Keywords deleted successfully.');
        },
        function (error) {
          deleteKeywords = [];
        }
      );
    };

    /* Add tags for selected Keywords in new page */
    $scope.addTagsModelNew = function (event) {
      var selected_keywords = _.where($rootScope.keywords, { checked: true });
      $timeout(function () {
        $mdDialog
          .show({
            templateUrl: 'themeX/keywords/_add_tags.html',
            controller: 'addTagToKeywords',
            resolve: {
              data: function () {
                return {
                  business_id: $scope.business_id,
                  selected_keywords: selected_keywords,
                  all_keywords: $scope.all_keywords
                };
              }
            }
          })
          .then(
            function (status) {
              if (status && status === 'success') {
                $scope.getTags();
              }
            },
            function (cancel) { }
          );
      });
    };

    $scope.get_laststring_url = function (url) {
      var parser = document.createElement('a');
      parser.href = url;
      if (parser.pathname == '/') {
        return 'home page';
      } else {
        return parser.pathname;
      }
    };

    $scope.toggle = function (show_hide, $event) {
      $event.preventDefault();
      switch (show_hide) {
        case 1:
          $rootScope.hide_keywords = !$rootScope.hide_keywords;
          break;
        case 2:
          $rootScope.hide_google = !$rootScope.hide_google;
          break;
        case 4:
          $rootScope.hide_search_volume = !$rootScope.hide_search_volume;
          break;
        case 5:
          $rootScope.hide_cpc = !$rootScope.hide_cpc;
          break;
        case 6:
          $rootScope.hide_kdi = !$rootScope.hide_kdi;
          break;
        default:
      }
    };
  }
]);

clickxApp.controller('EditKeyword', [
  '$scope',
  '$rootScope',
  'Business',
  'keyword',
  '$timeout',
  '$mdDialog',
  '$location',
  function (
    $scope,
    $rootScope,
    Business,
    keyword,
    $timeout,
    $mdDialog,
    $location
  ) {
    $scope.keyword = keyword;
    var country_code = $scope.keyword.locale
      ? $scope.keyword.locale.split('-')[1].trim() || 'us'
      : null;
    $scope.options = {
      types: ['(regions)'],
      componentRestrictions: {
        country: country_code
      }
    };

    $scope.allCountryList = function () {
      Business.country_locale(function (response) {
        $scope.countryList = response.data;
      });
    };

    $scope.setLocation = function () {
      var country = $scope.getCountryFromLocale($scope.keyword.locale);
      var country_code = $scope.keyword.locale
        ? $scope.keyword.locale.split('-')[1].trim() || 'us'
        : null;
      $scope.options = {
        types: ['(regions)'],
        componentRestrictions: {
          country: country_code
        }
      };
      $scope.keyword.city = country;
    };

    $scope.getCountryFromLocale = function (locale) {
      country = 'United States - English';
      $.each($scope.countryList, function (i, locale_info) {
        if (locale == locale_info.locale) {
          country = locale_info.country;
        }
      });
      return country.split('-')[0].trim() || 'United States';
    };

    $scope.closeModal = function (e) {
      $mdDialog.cancel('close');
    };

    $scope.update = function (keyword) {
      Business.update_keyword({ id: keyword.id, keyword: keyword }, function (
        res
      ) {
        $scope.closeModal();
        $location.path('/rankings');
      });
    };

    $scope.allCountryList();
  }
]);

var callGoogleKeywordChart = function (chartData) {
  return $('#all-time-keywords-google').highcharts(chartData);
};
