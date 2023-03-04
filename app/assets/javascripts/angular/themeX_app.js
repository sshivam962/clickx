var angular_modules = [
  'ngRoute',
  'ngResource',
  'ngInflection',
  'templates',
  'cloudinary',
  'angularFileUpload',
  'ngCookies',
  'minicolors',
  'smart-table',
  'infinite-scroll',
  'angularMoment',
  'ngAudio',
  'ngStorage',
  'angular-redactor',
  'ngMaterial',
  'angular-loading-bar',
  'ngAnimate',
  'as.sortable',
  'ui.select',
  'ngSanitize',
  'daterangepicker',
  'ngCsv',
  'ngFileUpload',
  'ngclipboard',
  'angular-jqcloud',
  'ngAutocomplete',
  'angularPayments',
  'ui.slimscroll',
  'xeditable',
  'ui.sortable',
  'Tek.progressBar',
  'isteven-omni-bar',
  '720kb.tooltips',
  'wu.masonry',
  'ui.gravatar',
  'mgo-angular-wizard',
  'thatisuday.dropzone',
  'ngMaterialDateRangePicker',
  'bmd.bootstrap',
  'tooltips',
  'gavruk.card',
  'vsGoogleAutocomplete',
  'lrDragNDrop',
  'angular-bind-html-compile',
  'dndLists'
];

// Listed alphabetically for readability
var bu_route_modules = [
  'clickxApp.Adwords',
  'clickxApp.ClientBilling',
  'clickxApp.Businesses',
  'clickxApp.ClientBilling',
  'clickxApp.Contents',
  'clickxApp.FacebookAds',
  'clickxApp.GoogleAnalytics',
  'clickxApp.Integrations',
  'clickxApp.Keywords',
  'clickxApp.Locations',
  'clickxApp.Questionnaire',
  'clickxApp.SearchConsole',
  'clickxApp.SiteAudit',
  'clickxApp.Users',
  'clickxApp.FacebookAds',
  'clickxApp.SearchTerms',
  'clickxApp.OnboardingProcedures'
];

Dropzone.autoDiscover = false;

var modules = angular_modules.concat(bu_route_modules);

var clickxApp = angular.module('clickxApp', modules);

clickxApp.config([
  '$routeProvider',
  '$locationProvider',
  function ($routeProvider, $locationProvider) {
    $routeProvider.otherwise({
      redirectTo: function () {
        window.location.href = dashboard_url;
      }
    });
  }
]);

clickxApp.config([
  'dropzoneOpsProvider',
  function (dropzoneOpsProvider) {
    dropzoneOpsProvider.setOptions({
      url:
        'https://api.cloudinary.com/v1_1/' +
        $.cloudinary.config().cloud_name +
        '/upload',
      addRemoveLinks: true,
      dictDefaultMessage: 'Click Here or Drag Files Here to Upload',
      dictRemoveFile: 'Remove',
      dictResponseError: 'Could not upload this file',
      paramName: 'file',
      maxFilesize: 10,
      method: 'POST',
      uploadMultiple: true,
      parallelUploads: 5,
      maxFiles: 10
    });
  }
]);

clickxApp.run([
  '$rootScope',
  '$location',
  'editableOptions',
  '$window',
  '$localStorage',
  '$http',
  'PDFMakeConfig',
  'Business',
  function (
    $rootScope,
    $location,
    editableOptions,
    $window,
    $localStorage,
    $http,
    PDFMakeConfig,
    Business
  ) {
    if (is_business_user && current_business) {
      var keywordParams = {
        limit: 50,
        offset: 0,
        sort: 'google_ranking_change',
        sort_order: 'false',
        time_string: 'all_time',
        id: current_business,
        ignoreLoadingBar: true
      };
      $rootScope.keywordResult = Business.business_keywords(keywordParams);
      $rootScope.keywordChartResult = Business.get_datewise_rankings({
        id: current_business,
        date_string: 'all_time',
        ignoreLoadingBar: true
      });
    }

    $rootScope.updateNotification = function () {
      $http({
        method: 'GET',
        url: '/notifications.json'
      }).then(
        function Success(response) {
          $rootScope.notifications = response.data.notifications;
          $rootScope.notifications_count = response.data.notifications_count;
        },
        function Error(response) {
          $rootScope.notifications = [];
        }
      );
    };

    if (typeof environment != 'undefined') {
      $rootScope.environment = environment;
    }
    editableOptions.theme = 'bs3'; // xeditable bootstrap3 theme. Can be also 'bs2', 'default'
    $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
      $('.modal').hide();
      if (window.ga != undefined) {
        ga('send', 'pageview', $location.path());
      }

      // Changes Title
      if (current && current.$$route && current.$$route.title) {
        var app_name_appended = current.$$route.title.replace(
          /\_\_app\_name\_\_/,
          $rootScope.app_name
        );
        $rootScope.title = app_name_appended || 'Dashboard';
      } else {
        $rootScope.title = 'Dashboard';
      }

      // Notification Update
      // $rootScope.updateNotification();
      $rootScope.previousRouteObject = previous;
    });

    /**
     * @uses Navigate to previous url
     */
    $rootScope.goBackCommon = function () {
      'use strict';
      $window.history.back();
    };

    $rootScope.rejectHash = function (hash, key, value) {
      var temp = {};
      temp[key] = value;
      return _.without(hash, _.findWhere(hash, temp));
    };

    $rootScope.pdf_export = function (id) {
      html2canvas(document.getElementById(id), {}).then(function(canvas) {
        var docDefinition = {
          content: [
            {
              image: canvas.toDataURL(),
              width: 500
            }
          ]
        };
        pdfMake.createPdf(docDefinition).download(id + '.pdf');
      });
    };

    $rootScope.defaultDROptions = {
      maxDate: moment().format('MM/DD/YYYY'),
      format: 'MM/DD/YYYY',
      ranges: {
        Today: [moment().format('MM/DD/YYYY'), moment().format('MM/DD/YYYY')],
        Yesterday: [
          moment()
            .subtract('days', 1)
            .format('MM/DD/YYYY'),
          moment()
            .subtract('days', 1)
            .format('MM/DD/YYYY')
        ],
        'Last 7 Days': [
          moment()
            .subtract('days', 7)
            .format('MM/DD/YYYY'),
          moment().format('MM/DD/YYYY')
        ],
        'Last 30 Days': [
          moment()
            .subtract('days', 30)
            .format('MM/DD/YYYY'),
          moment().format('MM/DD/YYYY')
        ],
        'This Month': [
          moment()
            .startOf('month')
            .format('MM/DD/YYYY'),
          moment()
            .endOf('month')
            .format('MM/DD/YYYY')
        ],
        'Last Month': [
          moment()
            .subtract('month', 1)
            .startOf('month')
            .format('MM/DD/YYYY'),
          moment()
            .subtract('month', 1)
            .endOf('month')
            .format('MM/DD/YYYY')
        ]
      },
      opens: 'left',
      startDate: moment().format('MM/DD/YYYY'),
      endDate: moment().format('MM/DD/YYYY')
    };
    $rootScope.rp_date = {
      startDate: moment()
        .subtract(30, 'days')
        .format('MM/DD/YYYY'),
      endDate: moment().format('MM/DD/YYYY')
    };

    var tempDate = moment()
      .subtract(30, 'days')
      .format('YYYY-MM-DD');

    $rootScope.isFutureDate = function (d) {
      var date = d.$date ? d.$date : d;
      return date && date.getTime() > new Date().getTime();
    };

    $rootScope.mdCustomTemplates = [
      {
        name: 'Last 30 Days',
        dateStart: new Date(tempDate),
        dateEnd: new Date()
      }
    ];

    $rootScope.selectedRange = {
      selectedTemplate: 'Last 30 Days',
      selectedTemplateName: 'Last 30 Days',
      dateStart: new Date(tempDate),
      dateEnd: new Date(),
      fullscreen: true,
      firstDayOfWeek: 0
    };

    $rootScope.date = {
      startDate: moment()
        .subtract(30, 'days')
        .format('YYYY-MM-DD'),
      endDate: moment().format('YYYY-MM-DD')
    };

    // get current month first date and last date
    $rootScope.current_month_first_date = moment()
      .startOf('month')
      .format('YYYY-MM-DD');
    $rootScope.current_month_last_date = moment()
      .endOf('month')
      .format('YYYY-MM-DD');

    /** FACEBOOK INTEGRATION **/
    $window.fbAsyncInit = function () {
      FB.init({
        appId: fb_app_id,
        xfbml: true,
        version: 'v3.3'
      });
    };

    (function (d, s, id) {
      var js,
        fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {
        return;
      }
      js = d.createElement(s);
      js.id = id;
      js.src = '//connect.facebook.net/en_US/sdk.js';
      fjs.parentNode.insertBefore(js, fjs);
    })(document, 'script', 'facebook-jssdk');
    /** EOF FACEBOOK INTEGRATION **/

    /** PDF Make default configuration **/
    $rootScope.pdfMakeConfig = PDFMakeConfig.defaultConfig();

    /** end PDF Make default configuration **/
  }
]);

clickxApp.config([
  'cfpLoadingBarProvider',
  '$windowProvider',
  function (cfpLoadingBarProvider, $windowProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
    cfpLoadingBarProvider.includeBar = true;
    var $window = $windowProvider.$get();
    try {
      //devolopment
      //Stripe.setPublishableKey("pk_test_6hT45G83kllMxWaBQ3oh7Z43")
      //production
      Stripe.setPublishableKey('pk_live_o3EtVf1Yr9CwzoRIcWpt8tGs');
      $window.Stripe = Stripe;
    } catch (error) { }

    // $window.Stripe = Stripe;
    cfpLoadingBarProvider.latencyThreshold = 400;

    /* Set fonts for PDFMake */

    pdfMake.fonts = {
      Roboto: {
        normal: 'Roboto-Regular.ttf',
        bold: 'Roboto-Medium.ttf',
        italics: 'Roboto-Italic.ttf',
        bolditalics: 'Roboto-MediumItalic.ttf'
      },
      fontAwesome: {
        normal: 'fontawesome-webfont.ttf',
        bold: 'fontawesome-webfont.ttf'
      }
    };

    /* End fonts for PDFMake */
  }
]);

clickxApp.config([
  'stConfig',
  function (stConfig) {
    stConfig.pagination.template = 'themeX/shared/_pagination.html';
  }
]);

function commonGetCookies(cname) {
  var name = cname + '=';
  var ca = document.cookie.split(';');
  for (var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) === 0) {
      return c.substring(name.length, c.length);
    }
  }
  return '';
}
