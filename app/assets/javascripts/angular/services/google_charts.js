clickxApp.factory('GoogleCharts', [
  'MonthNames',
  function(MonthNames) {
    var GoogleCharts = {};
    GoogleCharts.get_line_chart_config = function() {
      return {
        chart_config: {
          type: 'area',
          backgroundColor: '#fff',
          height: 350,
          spacingTop: 20
        }
      };
    };

    GoogleCharts.get_column_chart_config = function() {
      return {
        chart_config: {
          type: 'column',
          backgroundColor: '#fff',
          height: 350,
          spacingTop: 20
        }
      };
    };

    GoogleCharts.generic_pie_chart_data = function(ga_data) {
      total_sum = _.reduce(
        [
          ga_data.referral,
          ga_data.organic,
          ga_data.paid,
          ga_data.direct,
          ga_data.social,
          ga_data.email,
          ga_data.others
        ],
        function(memo, num) {
          return memo + num;
        },
        0
      );
      return {
        chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          backgroundColor: '#fff',
          height: 140
        },
        exporting: {
          enabled: false
        },
        title: {
          text: ''
        },
        tooltip: {
          pointFormat: '{point.percentage:.1f}%</b>'
        },
        plotOptions: {
          pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
              enabled: false
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
        legend: {
          align: 'right',
          layout: 'vertical',
          verticalAlign: 'top',
          x: 20,
          y: 5
        },
        series: [
          {
            type: 'pie',
            name: 'Visitors',
            data: [
              ['Referral', (ga_data.referral / total_sum) * 100],
              ['Direct', (ga_data.direct / total_sum) * 100],
              ['Organic Search', (ga_data.organic / total_sum) * 100],
              ['Paid Search', (ga_data.paid / total_sum) * 100],
              ['Social', (ga_data.social / total_sum) * 100],
              ['Email', (ga_data.email / total_sum) * 100],
              ['(Others)', (ga_data.others / total_sum) * 100]
            ]
          }
        ],
        credits: {
          enabled: false
        }
      };
    };

    GoogleCharts.users_chart = function(users_data, graph_option) {
      curr_month = get_current_month_with_graph_option(users_data, graph_option);
      visits_data = [];
      visitors_data = [];
      page_visits = [];
      bounce_data = [];
      avg_session_data = [];
      avg_session_durations = [];
      session_conv_rate_data = [];
      page_per_visit_data = [];
      _.each(_.values(users_data), function(data) {
        visits_data.push(data[0]);
        visitors_data.push(data[1]);
        page_per_visit_data.push(data[2]);
        avg_session_durations.push(data[3]);
        session_conv_rate_data.push(data[4]);
        bounce_data.push(data[5]);
      });
      return [
        visits_chart_data(curr_month, visits_data),
        visitor_chart_data(curr_month, visitors_data),
        page_per_visit_chart_data(curr_month, page_per_visit_data),
        avg_session_chart_data(curr_month, avg_session_durations, ""),
        new_visit_chart_data(curr_month, session_conv_rate_data),
        bounce_chart_data(curr_month, bounce_data, graph_option),
      ];
    };

    GoogleCharts.social_sessions_chart = function(data) {
      curr_month = get_current_month(data.all_sessions);
      social_sessions = _.map(_.values(data.social_sessions), function(row) {
        return row;
      });
      all_sessions = _.map(_.values(data.all_sessions), function(row) {
        return row;
      });
      return [
        social_graph(curr_month, social_sessions),
        social_graph(curr_month, all_sessions, 'All Sessions')
      ];
    };

    GoogleCharts.users_map = function(map_data, key) {
      _.each(map_data, function(data) {
        switch (key) {
          case 1:
            data.value = data.visits;
            title_name = 'Visits';
            break;
          case 2:
            data.value = data.new_visits;
            title_name = 'Session Conversion Rate';
            break;
          case 3:
            data.value = data.bounce;
            title_name = 'Bounce Rate';
            break;
          case 4:
            title_name = 'Avg. Time on Site';
            break;
          case 5:
            data.value = data.page_per_session;
            title_name = 'Pages/Visit';
            break;
        }
        if (data.site == 'United States')
          data.site = 'United States of America';
      });
      return {
        title: {
          text: ''
        },

        mapNavigation: {
          enabled: false,
          buttonOptions: {
            verticalAlign: 'bottom'
          }
        },

        colorAxis: {
          min: 0
        },

        series: [
          {
            data: map_data,
            mapData: Highcharts.maps['custom/world-highres2'],
            joinBy: ['name', 'site'],
            name: title_name,
            states: {
              hover: {
                color: '#BADA55'
              }
            },
            dataLabels: {
              enabled: false,
              format: '{point.name}'
            }
          }
        ],
        tooltip: {
          formatter: function() {
            if (key == 4) {
              return (
                this.series.name +
                '<br>' +
                this.key +
                ': ' +
                this.point.avg_session
              );
            } else {
              return (
                this.series.name + '<br>' + this.key + ': ' + this.point.value
              );
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    (GoogleCharts.search_charts = function(search_data) {}),
      (avg_session_chart_data = function(curr_month, data, durations) {
        return {
          chart: GoogleCharts.get_line_chart_config().chart_config,
          title: {
            text: ''
          },
          xAxis: [
            {
              categories: curr_month,
              lineColor: '#ffaa80',
              lineWidth: 3,
              tickColor: '#ffaa80',
              tickWidth: 3
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
              align: 'left'
            }
          },
          tooltip: {
            formatter: function() {
              var date = new Date(null);
              date.setSeconds(this.y);
              return (
                this.x +
                '<br><b>Avg. Time on Site : ' +
                date.toISOString().substr(11, 8) +
                '</b>'
              );
            }
          },
          series: [
            {
              name: 'Current Period',
              data: data,
              color: '#ffccb3',
              lineColor: '#ffaa80'
            }
          ],
          plotOptions: {
            area: {
              fillOpacity: 0.5,
              marker: {
                enabled: false
              }
            }
          },
          credits: {
            enabled: false
          }
        };
      });

    bounce_chart_data = function(curr_month, data, graph_option) {
      if (graph_option == 'month' || graph_option == 'year') {
        return {
          chart: GoogleCharts.get_column_chart_config().chart_config,
          title: {
            text: ''
          },
          bars: 'vertical',
          xAxis: [
            {
              categories: curr_month
            }
          ],
          yAxis: {
            min: 0
          },
          navigation: {
            buttonOptions: {
              align: 'left'
            }
          },
          tooltip: {
            formatter: function() {
              return (
                this.x + '<br><b>Bounce Rate : ' + this.y.toFixed(2) + '%</b>'
              );
            },
            trigger: 'focus'
          },
          series: [
            {
              name: 'Current Period',
              data: data,
              color: '#ffccb3',
              lineColor: '#ffaa80'
            }
          ],
          plotOptions: {
            bar: {
              dataLabels: {
                enabled: true
              }
            }
          },
          credits: {
            enabled: false
          }
        };
      } else {
        return {
          chart: GoogleCharts.get_line_chart_config().chart_config,
          title: {
            text: ''
          },
          xAxis: [
            {
              categories: curr_month,
              lineColor: '#ffaa80',
              lineWidth: 3,
              tickColor: '#ffaa80',
              tickWidth: 3
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
              align: 'left'
            }
          },
          tooltip: {
            formatter: function() {
              return (
                this.x + '<br><b>Bounce Rate : ' + this.y.toFixed(2) + '%</b>'
              );
            }
          },
          series: [
            {
              name: 'Current Period',
              data: data,
              color: '#ffccb3',
              lineColor: '#ffaa80'
            }
          ],
          plotOptions: {
            area: {
              fillOpacity: 0.5,
              marker: {
                enabled: false
              }
            }
          },
          credits: {
            enabled: false
          }
        };
      }
    };

    social_graph = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
          }
        ],
        yAxis: {
          plotLines: [
            {
              value: 0,
              width: 1,
              color: '#808080'
            }
          ]
        },
        navigation: {
          buttonOptions: {
            align: 'left'
          }
        },
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Sessions : ' + this.y + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };
    new_visit_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
            align: 'left'
          }
        },
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Conversion Rate : ' + this.y.toFixed(2) + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    page_per_visit_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
            align: 'left'
          }
        },
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Page/Visit : ' + this.y.toFixed(2) + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    visitor_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
            align: 'left'
          }
        },
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Visitors : ' + this.y + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    visits_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
            align: 'left'
          }
        },
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Visits : ' + this.y + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    GoogleCharts.goals_chart = function(goals_data) {
      curr_month = get_current_month(goals_data);
      completion_data = [];
      value_data = [];
      conversion_data = [];
      abandonment_data = [];
      _.each(_.values(goals_data), function(goal_count) {
        completion_data.push(goal_count[0]);
        value_data.push(goal_count[1]);
        conversion_rate =
          Math.round((goal_count[0] / goal_count[2]) * 100 * 100) / 100;
        conversion_data.push(conversion_rate || null);
        abandonment_data.push(goal_count[3]);
      });
      return [
        completion_chart_data(curr_month, completion_data),
        value_chart_data(curr_month, value_data),
        conversion_chart_data(curr_month, conversion_data),
        abandonment_chart_data(curr_month, abandonment_data)
      ];
    };

    completion_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Completed Goals : ' + this.y + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    value_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Goal Value : ' + this.y + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    conversion_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
        tooltip: {
          formatter: function() {
            return (
              this.x + '<br><b>Conversion Rate : ' + this.y.toFixed(2) + '</b>'
            );
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    abandonment_chart_data = function(curr_month, data) {
      return {
        chart: GoogleCharts.get_line_chart_config().chart_config,
        title: {
          text: ''
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3
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
        tooltip: {
          formatter: function() {
            return this.x + '<br><b>Abandonment Rate : ' + this.y + '</b>';
          }
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80'
          }
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false
            }
          }
        },
        credits: {
          enabled: false
        }
      };
    };

    get_current_month_with_graph_option = function(data, graph_option) {
      if ((graph_option == 'date') || (graph_option == 'week')) {
        return get_current_month(data)
      }
      else {
        return _.map(_.keys(data), function(date) {
          return (
            MonthNames.getShortMonthName(
              [
                date.slice(0, 4),
                '-',
                date.slice(4, 6),
                '-',
                date.slice(6, 8)
              ].join('')
            ) +
            '. ' +
            date.slice(0, 4)
          );
        });
      }
    }

    get_current_month = function(data) {
      return _.map(_.keys(data), function(date) {
        return (
          MonthNames.getShortMonthName(
            [
              date.slice(0, 4),
              '-',
              date.slice(4, 6),
              '-',
              date.slice(6, 8)
            ].join('')
          ) +
          '. ' +
          date.slice(6, 8) +
          '. ' +
          date.slice(0, 4)
        );
      });
    };
    return GoogleCharts;
  }
]);
