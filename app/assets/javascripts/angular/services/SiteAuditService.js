clickxApp.factory('SiteAuditService', [
  '$resource',
  function($resource) {
    var url = '/businesses/site_audits/:id/site_audit_issues_data.json';
    return $resource(
      url,
      {},
      {
        query: { method: 'GET', isArray: false },
        optimization: {
          url: 'businesses/site_audits/:id/site_audit_seo_analytics.json',
          method: 'GET'
        },
        backlink: {
          url: 'businesses/site_audits/:id/site_audit_backlink.json',
          method: 'GET'
        },
        page_error: {
          url: 'businesses/site_audits/:id/leo_report_rows.json',
          method: 'GET'
        },
        ranking: {
          url: 'businesses/site_audits/:id/site_audit_ranking_metrics.json',
          method: 'GET'
        },
        edit_error: {
          url: 'businesses/site_audits/:id/site_audit_edit_content.json',
          method: 'POST'
        }
      }
    );
  }
]);
