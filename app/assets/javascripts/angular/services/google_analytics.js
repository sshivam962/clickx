/**
 * Google Analytics Service
 */

var clickxApp = clickxApp || window.clickxApp;
clickxApp.service('GoogleAnalyticsService', [
  '$q',
  '$http',
  function($q, $http) {
    'use strict';
    this.landing_pages = function(bId, dates) {
      var defered = $q.defer();
      var formData = {};
      if (dates) {
        formData = dates;
      }
      $http({
        url: '/businesses/' + bId + '/google_landing_pages.json',
        type: 'GET',
        params: formData
      }).then(
        function(success) {
          defered.resolve(success);
        },
        function(error) {
          defered.reject(error);
        }
      );
      return defered.promise;
    };

    this.plot_device_pie_chart = function(element, options) {
      if (!element)
        throw new Error('Please provide an element to attach Chart');
      if (typeof options == 'undefined' && _.isObject(options)) {
        options = {};
      }
      var default_options = {
        chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          type: 'pie'
        },
        title: {
          text: 'Device Percentage'
        },
        tooltip: {
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
          pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
              enabled: true,
              format: '<b>{point.name}</b>: {point.percentage:.1f} %'
            },
            showInLegend: true
          },
          series: {
            point: {
              events: {
                legendItemClick: function() {
                  return false;
                }
              }
            }
          }
        },
        series: [
          {
            name: 'Device Percentage',
            colorByPoint: true,
            data: [
              {
                name: 'Desktops/Laptops',
                y: 56.33
              },
              {
                name: 'Tablets',
                y: 24.03,
                selected: true
              },
              {
                name: 'Mobile Phones',
                y: 19.64
              }
            ]
          }
        ]
      };

      options = _.extend(default_options, options);

      /* Attach element */
      $(element).highcharts(options);
    };
  }
]);
