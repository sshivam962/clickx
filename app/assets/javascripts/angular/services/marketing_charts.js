clickxApp.factory('MarketingCharts', [
  'MonthNames',
  function(MonthNames) {
    var MarketingCharts = {};
    MarketingCharts.get_line_chart_config = function() {
      return {
        chart_config: {
          backgroundColor: '#fff',
          height: 175,
          spacingTop: 5,
          type: 'areaspline'
        }
      };
    };
    MarketingCharts.performance = function(
      this_period,
      last_period,
      visits_goal,
      contacts_goal,
      customers_goal
    ) {
      var this_period = _.omit(this_period, 'total_counts');
      var last_period = _.omit(last_period, 'total_counts');
      month_nameMarketing_this_period = get_month_nameMarketing(this_period);
      month_nameMarketing_last_period = get_month_nameMarketing(last_period);

      this_period_visit_data = _.pluck(this_period, 'visit');
      var xtick = _.without(this_period_visit_data, null);
      xtickCount = xtick.length - 1;
      last_period_visit_data = _.pluck(last_period, 'visit');
      this_period_contact_data = _.pluck(this_period, 'contact');
      last_period_contact_data = _.pluck(last_period, 'contact');
      this_period_customer_data = _.pluck(this_period, 'customer');
      last_period_customer_data = _.pluck(last_period, 'customer');
      return [
        visit_perfomance_chart(
          this_period_visit_data,
          last_period_visit_data,
          month_nameMarketing_this_period,
          month_nameMarketing_last_period,
          xtickCount,
          visits_goal
        ),
        contact_perfomance_chart(
          this_period_contact_data,
          last_period_contact_data,
          month_nameMarketing_this_period,
          month_nameMarketing_last_period,
          xtickCount,
          contacts_goal
        ),
        customer_perfomance_chart(
          this_period_customer_data,
          last_period_customer_data,
          month_nameMarketing_this_period,
          month_nameMarketing_last_period,
          xtickCount,
          customers_goal
        )
      ];
    };

    visit_perfomance_chart = function(
      this_period_clicks_data,
      last_period_clicks_data,
      month_nameMarketing_this_period,
      month_nameMarketing_last_period,
      xtickCount,
      visits_goal
    ) {
      return {
        chart: MarketingCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: month_nameMarketing_this_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: true
            },
            tickPositions: [0, xtickCount]
          },
          {
            categories: month_nameMarketing_last_period,
            opposite: true,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          }
        ],
        yAxis: {
          min: 0,
          title: {
            text: ''
          },
          labels: {
            enabled: true
          },
          gridLineWidth: 0.4
        },
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          formatter: function() {
            if (this.series.name == 'Goals')
              return (
                'Visit Goals: ' +
                '<strong>' +
                parseInt(this.y).toLocaleString() +
                '</strong>'
              );
            return (
              this.x +
              ' ' +
              '<br>' +
              'Visits: ' +
              '<strong>' +
              parseInt(this.y).toLocaleString() +
              '</strong>'
            );
          }
        },
        series: [
          {
            type: 'line',
            name: 'Goals',
            color: '#bfbfbf',
            dashStyle: 'Dash',
            data: [[0, 0], [last_period_visit_data.length - 1, visits_goal]],
            showInLegend: false,
            lineWidth: 2,
            marker: {
              radius: 2
            }
          },
          {
            name: 'Previous Period',
            data: last_period_visit_data,
            color: '#d1e0e0',
            lineColor: '#b3cccc',
            xAxis: 1
          },
          {
            name: 'Visits',
            data: this_period_visit_data,
            color: '#3498dc',
            lineColor: '#0868a9'
          }
        ],
        credits: { enabled: false }
      };
    };
    contact_perfomance_chart = function(
      this_period_contact_data,
      last_period_contact_data,
      month_nameMarketing_this_period,
      month_nameMarketing_last_period,
      xtickCount,
      contacts_goal
    ) {
      return {
        chart: MarketingCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },

        xAxis: [
          {
            categories: month_nameMarketing_this_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: true
            },
            tickPositions: [0, xtickCount]
          },
          {
            categories: month_nameMarketing_last_period,
            opposite: true,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          }
        ],
        yAxis: {
          min: 0,
          title: {
            text: ''
          },
          labels: {
            enabled: true
          },
          gridLineWidth: 0.4
        },
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          formatter: function() {
            if (this.series.name == 'Goals')
              return (
                'Contact Goals: ' +
                '<strong>' +
                parseInt(this.y).toLocaleString() +
                '</strong>'
              );
            return (
              this.x +
              ' ' +
              '<br>' +
              'Contacts: ' +
              '<strong>' +
              parseInt(this.y).toLocaleString() +
              '</strong>'
            );
          }
        },
        series: [
          {
            type: 'line',
            name: 'Goals',
            color: '#bfbfbf',
            dashStyle: 'Dash',
            data: [
              [0, 0],
              [last_period_contact_data.length - 1, contacts_goal]
            ],
            showInLegend: false,
            lineWidth: 2,
            marker: {
              radius: 2
            }
          },
          {
            name: 'Previous Period',
            data: last_period_contact_data,
            color: '#d1e0e0',
            lineColor: '#b3cccc',
            xAxis: 1
          },
          {
            name: 'Contacts',
            data: this_period_contact_data,
            color: '#9b59b6',
            lineColor: '#570777'
          }
        ],
        credits: { enabled: false }
      };
    };

    customer_perfomance_chart = function(
      this_period_customer_data,
      last_period_customer_data,
      month_nameMarketing_this_period,
      month_nameMarketing_last_period,
      xtickCount,
      customers_goal
    ) {
      return {
        chart: MarketingCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: month_nameMarketing_this_period,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: true
            },
            tickPositions: [0, xtickCount]
          },
          {
            categories: month_nameMarketing_last_period,
            opposite: true,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          }
        ],
        yAxis: {
          min: 0,
          title: {
            text: ''
          },
          labels: {
            enabled: true
          },
          gridLineWidth: 0.4
        },
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          formatter: function() {
            if (this.series.name == 'Goals')
              return (
                'Customer Goals: ' +
                '<strong>' +
                parseInt(this.y).toLocaleString() +
                '</strong>'
              );
            return (
              this.x +
              ' ' +
              '<br>' +
              'Customers: ' +
              '<strong>' +
              parseInt(this.y).toLocaleString() +
              '</strong>'
            );
          }
        },
        series: [
          {
            type: 'line',
            name: 'Goals',
            color: '#bfbfbf',
            dashStyle: 'Dash',
            data: [
              [0, 0],
              [last_period_customer_data.length - 1, customers_goal]
            ],
            showInLegend: false,
            lineWidth: 2,
            marker: {
              radius: 2
            }
          },
          {
            name: 'Previous Period',
            data: last_period_customer_data,
            color: '#d1e0e0',
            lineColor: '#b3cccc',
            xAxis: 1
          },
          {
            name: 'Customers',
            data: this_period_customer_data,
            color: '#1cbc9c',
            lineColor: '#11a587'
          }
        ],
        credits: { enabled: false }
      };
    };

    get_month_nameMarketing = function(dates) {
      month_nameMarketing = [];
      _.each(_.keys(dates), function(month_date) {
        var short_month = MonthNames.getShortMonthName(month_date);
        short_month += '. ';
        month_nameMarketing.push(short_month + month_date.slice(8, 10));
      });
      return month_nameMarketing;
    };
    return MarketingCharts;
  }
]);

clickxApp.factory('funnelConsole', [
  'MonthNames',
  function(MonthNames) {
    var funnelConsole = {};

    funnelConsole.get_console_graphs = function(
      graph_data,
      graph_data_previous
    ) {
      current_month = get_month_names_search(graph_data);
      previous_month = get_month_names_search(graph_data_previous);
      var clicks = _.pluck(graph_data.rows, 'clicks');
      var prev_clicks = _.pluck(graph_data_previous.rows, 'clicks');
      var ctr = _.pluck(graph_data.rows, 'ctr');
      var prev_ctr = _.pluck(graph_data_previous.rows, 'ctr');
      var impressions = _.pluck(graph_data.rows, 'impressions');
      var prev_impressions = _.pluck(graph_data_previous.rows, 'impressions');
      var position = _.pluck(graph_data.rows, 'position');
      var prev_position = _.pluck(graph_data_previous.rows, 'position');
      var tooltip = ['Position', 'Impressions', 'Clicks', 'CTR'];

      chart_data = [];
      chart_data[0] = search_console_date_graphs(
        previous_month,
        current_month,
        prev_position,
        position,
        tooltip[0]
      );
      chart_data[1] = search_console_date_graphs(
        previous_month,
        current_month,
        prev_impressions,
        impressions,
        tooltip[1]
      );
      chart_data[2] = search_console_date_graphs(
        previous_month,
        current_month,
        prev_clicks,
        clicks,
        tooltip[2]
      );
      chart_data[3] = search_console_date_graphs(
        previous_month,
        current_month,
        prev_ctr,
        ctr,
        tooltip[3]
      );
      return chart_data;
    };

    search_console_date_graphs = function(
      prev_month,
      curr_month,
      data1,
      data2,
      tooltip
    ) {
      return {
        chart: {
          type: 'areaspline',
          height: 250
        },
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: prev_month,
            opposite: true,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          },
          {
            categories: curr_month,
            tickWidth: 0,
            lineWidth: 0,
            labels: {
              enabled: false
            }
          }
        ],
        yAxis: {
          plotLines: [
            {
              value: 0,
              width: 1,
              color: '#808080'
            }
          ],
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
              ' <br> ' +
              tooltip +
              ' :' +
              '<b>' +
              this.y +
              '</b>' +
              '</b>'
            );
          }
        },
        series: [
          {
            name: 'Previous Period',
            data: data1,
            color: '#d1e0e0',
            lineColor: '#b3cccc'
          },
          {
            name: tooltip,
            data: data2,
            color: '#ffccb3',
            lineColor: '#ffaa80',
            xAxis: 1
          }
        ],
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: { enabled: false }
      };
    };

    get_month_names_search = function(data) {
      month_names_search = [];
      _.each(data.rows, function(fields) {
        month_date = fields.keys[0];
        var short_month = MonthNames.getShortMonthName(month_date);
        short_month += '. ';
        month_names_search.push(short_month + month_date.slice(8, 10));
      });
      return month_names_search;
    };

    return funnelConsole;
  }
]);
