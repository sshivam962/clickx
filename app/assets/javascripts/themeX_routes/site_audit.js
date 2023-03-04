angular.module('clickxApp.SiteAudit', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    /***start beta*****/
    $routeProvider.when('/site_audit', {
      templateUrl: 'themeX/site_audits/site_audit.html',
      controller: 'SiteAudit',
      title: 'Site Audit | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Site Audit', link: '/#/site_audit' }
        ]
      }
    });
    $routeProvider.when('/:business_id/page_analytics', {
      templateUrl: 'themeX/site_audits/page_analytics.html',
      controller: 'pageAnalytics',
      title: 'Site Audit Page Analytics | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Site Audit', link: '/#/site_audit' }
        ]
      }
    });
  }
]);
