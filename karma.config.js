/**
 * Created by sibin on 26/1/17.
 */

/**
 * https://github.com/codysims/karma-ng-haml2js-preprocessor
 * https://github.com/karma-runner/karma-ng-html2js-preprocessor
 */

module.exports = function(config){
  config.set({
    basePath:'./',
    singleRun:false,
    files:[
      'bower_components/jquery/dist/jquery.js',
      'bower_components/jquery-ui/jquery-ui.js',
      'bower_components/bootstrap/dist/js/bootstrap.js',
      'app/assets/javascripts/stripe.js',
      'bower_components/angular/angular.js',
      'bower_components/angular-loader/angular-loader.js',
      'bower_components/angular-route/angular-route.js',
      'bower_components/angular-resource/angular-resource.js',
      'bower_components/angular-animate/angular-animate.js',
      'bower_components/angular-touch/angular-touch.js',
      'bower_components/angular-cookies/angular-cookies.js',
      'bower_components/angular-sanitize/angular-sanitize.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'app/assets/javascripts/highcharts.js',
      'app/assets/javascripts/highcharts-more.js',
      'app/assets/javascripts/highmap-plugin.js',
      'app/assets/javascripts/highmap-world.js',
      'app/assets/javascripts/exporting.js',
      'app/assets/javascripts/moment.min.js',
      'app/assets/javascripts/ui-bootstrap-tpls-0.14.1.js',
      'app/assets/javascripts/*.js',
      'app/assets/javascripts/grid/*.js',
      //'app/assets/javascripts/templates/**/*.haml',
      'app/assets/javascripts/angular-test/unit-test/mock-modules.js',
      'app/assets/javascripts/angular/clickx_app.js',
      'app/assets/javascripts/angular/controller/**/*.js',
      'app/assets/javascripts/angular/directives/**/*.js',
      'app/assets/javascripts/angular/filters/**/*.js',
      'app/assets/javascripts/angular/services/**/*.js',
      'app/assets/javascripts/angular-test/unit-test/controllers/**/*.js',
      'app/assets/javascripts/angular-test/unit-test/service/**/*.js',
      'app/assets/javascripts/angular-test/unit-test/directives/**/*.js',
      'app/assets/javascripts/angular-test/unit-test/filters/**/*.js'
    ],
    exclude:[
      'app/assets/javascripts/application.js',
      'app/assets/javascripts/highmap-data.js',
      'app/assets/javascripts/highmap-exporting.js',
      'app/assets/javascripts/tooltip.js',
      'app/assets/javascripts/popover.js',
      'app/assets/javascripts/ui-bootstrap-*.js',
      'app/assets/javascripts/toastr.js',
      'app/assets/javascripts/toastr.min.js',
      'app/assets/javascripts/review-layout.js'
    ],
    autoWatch: true,
    frameworks:['jasmine'],
    browsers:['Firefox'],
    plugins:[
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      'karma-jasmine',
      'karma-junit-reporter',
      'karma-spec-reporter',
      'karma-html-reporter',
      'karma-ng-html2js-preprocessor',
      'karma-ng-haml2js-preprocessor',
      'karma-verbose-reporter'
    ],
    junitReporter: {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    },
    preprocessors: {
      '**/*.html': ['ng-html2js'],
      '**/*.haml': ['ng-haml2js']
    },
    /* HTML */
    //ngHtml2JsPreprocessor: {
    //  // we want all templates to be loaded in the same module called 'templates'
    //  moduleName: 'templates'
    //},
    ngHaml2JsPreprocessor:{
      moduleName: 'templates'
    },
    reporters: ['progress', 'html'],
    htmlReporter: {
      outputDir: 'karma_html', // where to put the reports
      templatePath: null, // set if you moved jasmine_template.html
      focusOnFailures: true, // reports show failures on start
      namedFiles: false, // name files instead of creating sub-directories
      pageTitle: null, // page title for reports; browser info by default
      urlFriendlyName: false, // simply replaces spaces with _ for files/dirs
      reportName: 'report-summary-filename', // report summary filename; browser info by default
      // experimental
      preserveDescribeNesting: false, // folded suites stay folded
      foldAll: false, // reports start folded (only with preserveDescribeNesting)
    }
  })
}
