clickxApp.directive('onClickChart', [
  '$window',
  '$rootScope',
  function($window, $rootScope) {
    return {
      link: function($scope, element, attrs) {
        $('#' + attrs.id).on('mouseup', function() {
          if (
            attrs.id == 'contact_line_chart' ||
            attrs.id == 'customer_line_chart' ||
            attrs.id == 'contacts-by-source' ||
            attrs.id == 'contacts-per-day-chart'
          ) {
            $window.location.href = '#/leads';
          } else if (
            attrs.id == 'visits_line_chart' ||
            attrs.id == 'visitors_charts' ||
            attrs.id == 'page_per_visit_charts' ||
            attrs.id == 'avg_session_charts' ||
            attrs.id == 'new_visits_charts' ||
            attrs.id == 'bounce_charts'
          ) {
            $window.location.href = '#/google_analytics';
          } else if (
            attrs.id == 'position' ||
            attrs.id == 'impression' ||
            attrs.id == 'clicks' ||
            attrs.id == 'ctr'
          ) {
            var search_consoleUrl =
              '#/' + $rootScope.current_business + '/search_console/queries';
            $window.location.href = search_consoleUrl;
          } else if (
            attrs.id == 'clicks_line_chart' ||
            attrs.id == 'impressions_line_chart' ||
            attrs.id == 'conversions_line_chart'
          ) {
            $window.location.href = '#/adwords';
          } else if (
            attrs.id == 'clicks_line_chart_display' ||
            attrs.id == 'impressions_line_chart_display' ||
            attrs.id == 'conversions_line_chart_display'
          ) {
            $window.location.href = '#/display';
          } else if (
            attrs.id == 'donut-summary' ||
            attrs.id == 'donut-citation'
          ) {
            $window.location.href = '#/summary';
          } else if (
            attrs.id == 'calls_by_status_chart' ||
            attrs.id == 'unique_calls_chart'
          ) {
            $window.location.href = '#/calls';
          } else if (attrs.id == 'chart_div') {
            var reviewsUrl = '#/' + $rootScope.current_business + '/reviews';
            $window.location.href = reviewsUrl;
          } else if (attrs.id == 'analytics_pie_chart') {
            $window.location.href = '#/google_analytics';
          } else if (attrs.id == 'all-time-keywords-google') {
            $window.location.href = '#/rankings';
          }
        });
      }
    };
  }
]);
