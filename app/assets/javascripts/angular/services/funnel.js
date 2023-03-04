clickxApp.factory('funnelCharts', [
  'MonthNames',
  function(MonthNames) {
    var funnelCharts = {};

    funnelCharts.get_line_chart_config = function() {
      return {
        chart_config: {
          backgroundColor: '#fff',
          height: 250,
          type: 'areaspline',
          spacingTop: 20
        }
      };
    };

    funnelCharts.adwords_performance = function(this_period, last_period) {
      month_namesAdwords_this_period = get_month_namesAdwords(this_period);
      month_namesAdwords_last_period = get_month_namesAdwords(last_period);

      this_period_clicks_data = _.pluck(this_period, 'clicks');
      last_period_clicks_data = _.pluck(last_period, 'clicks');
      this_period_impressions_data = _.pluck(this_period, 'impressions');
      last_period_impressions_data = _.pluck(last_period, 'impressions');
      this_period_cost_data = _.map(_.pluck(this_period, 'cost'), function(n) {
        return Number((n / 1000000).toFixed(2));
      });
      last_period_cost_data = _.map(_.pluck(last_period, 'cost'), function(n) {
        return Number((n / 1000000).toFixed(2));
      });
      this_period_avg_cost_data = _.map(
        _.pluck(this_period, 'avg_cost'),
        function(n) {
          return Number((n / 1000000).toFixed(2));
        }
      );
      last_period_avg_cost_data = _.map(
        _.pluck(last_period, 'avg_cost'),
        function(n) {
          return Number((n / 1000000).toFixed(2));
        }
      );
      this_period_ctr_data = _.pluck(this_period, 'ctr');
      last_period_ctr_data = _.pluck(last_period, 'ctr');
      this_period_conversions_data = _.pluck(this_period, 'conversions');
      last_period_conversions_data = _.pluck(last_period, 'conversions');

      return [
        clicks_adwords_perfomance_chart(
          this_period_clicks_data,
          last_period_clicks_data,
          month_namesAdwords_this_period,
          month_namesAdwords_last_period
        ),
        impressions_adwords_perfomance_chart(
          this_period_impressions_data,
          last_period_impressions_data,
          month_namesAdwords_this_period,
          month_namesAdwords_last_period
        ),
        conversions_adwords_perfomance_chart(
          this_period_conversions_data,
          last_period_conversions_data,
          month_namesAdwords_this_period,
          month_namesAdwords_last_period
        )
      ];
    };
    clicks_adwords_perfomance_chart = function(
      this_period_clicks_data,
      last_period_clicks_data,
      month_namesAdwords_this_period,
      month_namesAdwords_last_period
    ) {
      return {
        chart: funnelCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: month_namesAdwords_this_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          },
          {
            categories: month_namesAdwords_last_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            },
            opposite: true
          }
        ],
        yAxis: {
          min: 0
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          formatter: function() {
            return (
              this.x +
              ' ' +
              '<br>' +
              'Clicks: ' +
              '<strong>' +
              this.y +
              '</strong>'
            );
          }
        },
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        series: [
          {
            name: 'Previous Period',
            data: last_period_clicks_data,
            color: '#d1e0e0',
            lineColor: '#b3cccc',
            xAxis: 1
          },
          {
            name: 'Clicks',
            data: this_period_clicks_data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        credits: { enabled: false }
      };
    };

    impressions_adwords_perfomance_chart = function(
      this_period_impressions_data,
      last_period_impressions_data,
      month_namesAdwords_this_period,
      month_namesAdwords_last_period
    ) {
      return {
        chart: funnelCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: month_namesAdwords_this_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          },
          {
            categories: month_namesAdwords_last_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            },
            opposite: true
          }
        ],
        yAxis: {
          min: 0
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          formatter: function() {
            return (
              this.x +
              ' ' +
              '<br>' +
              'Impressions: ' +
              '<strong>' +
              this.y +
              '</strong>'
            );
          }
        },
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        series: [
          {
            name: 'Previous Period ',
            data: last_period_impressions_data,
            color: '#d1e0e0',
            lineColor: '#b3cccc',
            xAxis: 1
          },
          {
            name: 'Impressions',
            data: this_period_impressions_data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        credits: { enabled: false }
      };
    };

    conversions_adwords_perfomance_chart = function(
      this_period_conversions_data,
      last_period_conversions_data,
      month_namesAdwords_this_period,
      month_namesAdwords_last_period
    ) {
      return {
        chart: funnelCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: month_namesAdwords_this_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          },
          {
            categories: month_namesAdwords_last_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            },
            opposite: true
          }
        ],
        yAxis: {
          min: 0
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          formatter: function() {
            return (
              this.x +
              ' ' +
              '<br>' +
              'Conversions: ' +
              '<strong>' +
              this.y +
              '</strong>'
            );
          }
        },
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        series: [
          {
            name: 'Previous Period',
            data: last_period_conversions_data,
            color: '#d1e0e0',
            lineColor: '#b3cccc',
            xAxis: 1
          },
          {
            name: 'Conversions',
            data: this_period_conversions_data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        credits: { enabled: false }
      };
    };

    get_month_namesAdwords = function(dates) {
      month_namesAdwords = [];
      _.each(_.keys(dates), function(month_date) {
        var short_month = MonthNames.getShortMonthName(month_date);
        short_month += '. ';
        month_namesAdwords.push(short_month + month_date.slice(8, 10));
      });
      return month_namesAdwords;
    };

    return funnelCharts;
  }
]);
