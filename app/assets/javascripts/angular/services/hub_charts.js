clickxApp.factory('HubCharts', [
  'MonthNames',
  function(MonthNames) {
    var HubCharts = {};
    var default_pie_chart = {
      chart: {
        height: 300,
        backgroundColor: '#fff',
        spacingTop: 20,
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false
      },
      title: {
        text: ''
      },
      tooltip: {
        formatter: function() {
          return this.y;
        }
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true
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
        align: 'center',
        layout: 'horizontal',
        verticalAlign: 'bottom',
        x: 20,
        y: 10,
        labelFormatter: function() {
          return this.name + '  ' + this.y;
        }
      },
      navigation: {
        buttonOptions: {
          enabled: false
        }
      },
      credits: {
        enabled: false
      }
    };
    HubCharts.backlinksChart = function(backlinksData) {
      callDoNutChart = [];
      callDoNutCitation = [];
      callDoNutChart = backlinksData.TrustFlow;
      callDoNutCitation = backlinksData.CitationFlow;
      return [
        backlinks_callDoNutChart(callDoNutChart),
        backlinks_callDoNutCitation(callDoNutCitation)
      ];
    };
    backlinks_callDoNutCitation = function(data) {
      return {
        chart: {
          type: 'solidgauge',
          marginTop: 10,
          height: 255
        },
        title: false,
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          enabled: false
        },
        pane: {
          startAngle: 0,
          endAngle: 360,
          background: [
            {
              // Track for Move
              outerRadius: '81%',
              innerRadius: '58%',
              backgroundColor: '#eee',
              borderWidth: 0
            }
          ]
        },
        yAxis: {
          min: 0,
          max: 100,
          lineWidth: 0,
          tickPositions: []
        },
        plotOptions: {
          solidgauge: {
            borderWidth: '24px',
            dataLabels: {
              enabled: true,
              format: '{y}',
              borderWidth: 0,
              style: {
                fontSize: '42px'
              },
              x: 0,
              y: -24
            },

            linecap: 'square',
            stickyTracking: false
          }
        },
        series: [
          {
            name: 'Move',
            borderColor: '#F7C151',
            data: [
              {
                color: '#CC992F',
                radius: '69%',
                innerRadius: '68%',
                y: data
              }
            ]
          }
        ]
      };
    };
    backlinks_callDoNutChart = function(data) {
      return {
        chart: {
          type: 'solidgauge',
          marginTop: 10,
          height: 255
        },
        title: false,
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        tooltip: {
          enabled: true
        },
        pane: {
          startAngle: 0,
          endAngle: 360,
          background: [
            {
              // Track for Move
              outerRadius: '81%',
              innerRadius: '58%',
              backgroundColor: '#eee',
              borderWidth: 0
            }
          ]
        },
        yAxis: {
          min: 0,
          max: 100,
          lineWidth: 0,
          tickPositions: []
        },
        plotOptions: {
          solidgauge: {
            borderWidth: '24px',
            dataLabels: {
              enabled: true,
              format: '{y}',
              borderWidth: 0,
              style: {
                fontSize: '42px'
              },
              x: 0,
              y: -24
            },

            linecap: 'square',
            stickyTracking: false
          }
        },
        series: [
          {
            name: 'Move',
            borderColor: '#F7C151',
            data: [
              {
                color: '#CC992F',
                radius: '69%',
                innerRadius: '68%',
                y: data
              }
            ]
          }
        ]
      };
    };
    get_month_name = function(users_data) {
      var month_name = [];

      _.each(_.keys(users_data), function(month_date) {
        var short_month = MonthNames.getShortMonthName(
          [
            month_date.slice(0, 4),
            '-',
            month_date.slice(4, 6),
            '-',
            month_date.slice(6, 8)
          ].join('')
        );
        short_month += '. ';
        month_name.push(short_month + month_date.slice(6, 8));
      });

      return month_name;
    };

    HubCharts.contacts_by_source = function(data) {
      return {
        chart: {
          type: 'bar'
        },
        colors: [
          '#7cb5ec',
          '#434348',
          '#90ed7d',
          '#f7a35c',
          '#8085e9',
          '#f15c80',
          '#e4d354',
          '#2b908f',
          '#f45b5b',
          '#91e8e1'
        ],
        title: {
          text: ''
        },
        xAxis: {
          type: 'category'
        },
        yAxis: {
          min: 0,
          title: {
            text: 'No. of contacts by source',
            align: 'high'
          },
          labels: {
            overflow: 'justify'
          }
        },
        plotOptions: {
          bar: {
            dataLabels: {
              enabled: true
            },
            colorByPoint: true
          }
        },
        legend: {
          enabled: false
        },
        credits: {
          enabled: false
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        series: [
          {
            data: data
          }
        ]
      };
    };

    HubCharts.call_status_pie_chart_data = function(status_data) {
      var call_status_pie_chart_data = angular.copy(default_pie_chart);
      call_status_pie_chart_data['series'] = [
        {
          type: 'pie',
          name: 'Calls_By_Status',
          data: [
            ['Answers', status_data.ANSWER || 0],
            ['No Answer', status_data.NOANSWER || 0],
            ['Cancel', status_data.CANCEL || 0]
          ]
        }
      ];
      call_status_pie_chart_data['chart'] = {
        height: 300
      };
      return call_status_pie_chart_data;
    };
    HubCharts.unique_calls_bar_chart_data = function(
      unique_calls_data,
      greater_than_five
    ) {
      return {
        chart: {
          type: 'column',
          height: 300,
          spacingRight: 20
        },
        title: {
          text: ''
        },
        xAxis: {
          categories: [
            '1 call',
            '2 calls',
            '3 calls',
            '4 calls',
            '5 calls',
            '>5 calls'
          ],
          crosshair: true
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        yAxis: {
          min: 0,
          title: {
            text: '# of Callers'
          }
        },
        tooltip: {
          headerFormat:
            '<span style="font-size:10px">{point.key}</span><table>',
          pointFormat:
            '<tr><td style="color:{series.color};padding:0">Times Called: </td><td style="pad' +
            'ding:0"><b>{point.y} calls</b></td></tr>',
          footerFormat: '</table>',
          shared: true,
          useHTML: true
        },
        plotOptions: {
          column: {
            pointPadding: 0.0,
            borderWidth: 0.0
          }
        },
        series: [
          {
            name: 'Unique Callers',
            data: [
              unique_calls_data[1] || 0,
              unique_calls_data[2] || 0,
              unique_calls_data[3] || 0,
              unique_calls_data[4] || 0,
              unique_calls_data[5] || 0,
              greater_than_five || 0
            ]
          }
        ],
        credits: {
          enabled: false
        }
      };
    };
    var colors = [
      '#c0392b',
      '#e74c3c',
      '#d35400',
      '#d35400',
      '#f39c12',
      '#f1c40f'
    ];

    HubCharts.ratings_bar_chart = function(ratings_data) {
      return {
        chart: {
          height: 470,
          type: 'bar',
          marginTop: 50
        },
        title: {
          text: ''
        },
        subtitle: {
          text: ''
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        xAxis: {
          categories: [
            '5stars',
            '4stars',
            '3stars',
            '2stars',
            '1stars',
            '0stars'
          ],
          title: {
            text: null
          },
          labels: {
            useHTML: true,
            style: {
              fontSize: '21px'
            },
            distance: 10,
            formatter: function() {
              return {
                '5stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class' +
                  '="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-' +
                  'star gold-star"></i>',
                '4stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class' +
                  '="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-' +
                  'star-o gold-star"></i>',
                '3stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class' +
                  '="fa fa-star gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa f' +
                  'a-star-o gold-star"></i>',
                '2stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class' +
                  '="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa' +
                  ' fa-star-o gold-star"></i>',
                '1stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star-o gold-star"></i><i cla' +
                  'ss="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="' +
                  'fa fa-star-o gold-star"></i>',
                '0stars':
                  '<i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i c' +
                  'lass="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class' +
                  '="fa fa-star-o gold-star"></i>'
              }[this.value];
            }
          }
        },
        yAxis: {
          min: 0,
          title: {
            text: null
          },
          labels: {
            overflow: 'justify'
          }
        },
        tooltip: {
          enabled: false
        },

        plotOptions: {
          bar: {
            dataLabels: {
              enabled: true
            }
          },
          series: {
            borderRadius: 3,
            pointWidth: 30
          }
        },
        legend: {
          enabled: false
        },
        credits: {
          enabled: false
        },
        series: [
          {
            data: [[5, parseInt(ratings_data[0])]],
            name: '5stars',
            color: colors[0]
          },
          {
            data: [[4, parseInt(ratings_data[1])]],
            name: '4stars',
            color: colors[1]
          },
          {
            data: [[3, parseInt(ratings_data[2])]],
            name: '3stars',
            color: colors[2]
          },
          {
            data: [[2, parseInt(ratings_data[3])]],
            name: '2stars',
            color: colors[3]
          },
          {
            data: [[1, parseInt(ratings_data[4])]],
            name: '1stars',
            color: colors[4]
          },
          {
            data: [[0, parseInt(ratings_data[5])]],
            name: '0stars',
            color: colors[5]
          }
        ]
      };
    };

    HubCharts.social_retargeting_chart = function(campaign_reports) {
      var campReport = campaign_reports;
      var startTime = {
        timestamp: moment(campReport[0].report_date, 'YYYY-MM-DD').format('x'),
        year: moment(campReport[0].report_date, 'YYYY-MM-DD').format('YYYY'),
        month: moment(campReport[0].report_date, 'YYYY-MM-DD').format('MM') - 1,
        day: moment(campReport[0].report_date, 'YYYY-MM-DD').format('DD'),
        hour: moment(campReport[0].report_date, 'YYYY-MM-DD').format('HH')
      };
      var impressions = [];
      var clicks = [];
      var costs = [];
      campaign_reports.map(function(value, index) {
        impressions.push(value.impressions);
        clicks.push(value.clicks);
        costs.push(value.costs);
      });
      return {
        chart: {
          type: 'areaspline',
          height: 350
        },
        title: {
          text: ''
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        legend: {
          layout: 'vertical',
          align: 'left',
          verticalAlign: 'top',
          x: 150,
          y: 100,
          floating: true,
          borderWidth: 1,
          backgroundColor:
            (Highcharts.theme && Highcharts.theme.legendBackgroundColor) ||
            '#FFFFFF'
        },
        xAxis: {
          type: 'datetime'
        },
        yAxis: {
          title: {
            text: '%'
          }
        },
        tooltip: {
          shared: true,
          valueSuffix: ''
        },
        credits: {
          enabled: false
        },
        plotOptions: {
          areaspline: {
            fillOpacity: 0.5,
            pointStart: Date.UTC(
              startTime.year,
              startTime.month,
              startTime.day
            ),
            pointInterval: customPointerInterval('day')
          }
        },
        series: [
          {
            name: 'Impressions',
            data: impressions
          },
          {
            name: 'Clicks',
            data: clicks
          },
          {
            name: 'Cost',
            data: costs
          }
        ]
      };
    };
    /////////////
    HubCharts.google_users_chart = function(users_data1, users_data2) {
      prev_month = get_previous_months(users_data1);
      curr_month = get_current_months(users_data2);
      visitors_data1 = [];
      page_visits1 = [];
      bounce_data1 = [];
      avg_session_data1 = [];
      avg_session_durations1 = [];
      new_visit_data1 = [];
      page_per_visit_data1 = [];
      visitors_data2 = [];
      page_visits2 = [];
      bounce_data2 = [];
      avg_session_data2 = [];
      avg_session_durations2 = [];
      new_visit_data2 = [];
      page_per_visit_data2 = [];

      _.each(_.values(users_data1), function(user_count) {
        new_visit_data1.push(user_count[0]);
        visitors_data1.push(user_count[1]);
        bounce_data1.push(user_count[2]);
        page_per_visit_data1.push(Math.round(user_count[4] * 100) / 100);

        var date = new Date(null);
        date.setSeconds(user_count[3]);
        avg_session_durations1.push(date.toISOString().substr(11, 8));
        avg_session_data1.push(user_count[3]);
      });
      _.each(_.values(users_data2), function(user_count) {
        new_visit_data2.push(user_count[0]);
        visitors_data2.push(user_count[1]);
        bounce_data2.push(user_count[2]);
        page_per_visit_data2.push(user_count[4]);

        var date = new Date(null);
        date.setSeconds(user_count[3]);
        avg_session_durations2.push(date.toISOString().substr(11, 8));
        avg_session_data2.push(user_count[3]);
      });
      return [
        visitor_chart_datas(
          prev_month,
          curr_month,
          visitors_data1,
          visitors_data2
        ),
        page_per_visit_chart_datas(
          prev_month,
          curr_month,
          page_per_visit_data1,
          page_per_visit_data2
        ),
        avg_session_chart_datas(
          prev_month,
          curr_month,
          avg_session_data1,
          avg_session_durations1,
          avg_session_data2,
          avg_session_durations2
        ),
        new_visit_chart_datas(
          prev_month,
          curr_month,
          new_visit_data1,
          new_visit_data2
        ),
        bounce_chart_datas(prev_month, curr_month, bounce_data1, bounce_data2)
      ];
    };
    avg_session_chart_datas = function(
      prev_month,
      curr_month,
      data1,
      durations1,
      data2,
      durations2
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
            var date = new Date(null);
            date.setSeconds(this.y);
            return (
              this.x +
              ' <br> Avg. Time on Site : <b>' +
              date.toISOString().substr(11, 8) +
              '</b></b>'
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
            name: 'Session Duration',
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
        credits: {
          enabled: false
        }
      };
    };

    bounce_chart_datas = function(prev_month, curr_month, data1, data2) {
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
            return this.x + ' <br> Bounce Rate : <b>' + this.y + '</b></b>';
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
            name: 'Bounce Rate',
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
        credits: {
          enabled: false
        }
      };
    };
    new_visit_chart_datas = function(prev_month, curr_month, data1, data2) {
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
            return this.x + ' <br> New Visits : <b>' + this.y + '</b></b>';
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
            name: 'New Session',
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
        credits: {
          enabled: false
        }
      };
    };

    page_per_visit_chart_datas = function(
      prev_month,
      curr_month,
      data1,
      data2
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
            return this.x + ' <br> Page/Visit : <b>' + this.y + '</b></br>';
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
            name: 'Pages/Session',
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
        credits: {
          enabled: false
        }
      };
    };

    visitor_chart_datas = function(prev_month, curr_month, data1, data2) {
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
            return this.x + ' <br> Visits : <b>' + this.y + '</b></br>';
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
            name: 'Visitors',
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
        credits: {
          enabled: false
        }
      };
    };
    get_current_months = function(users_data2) {
      curr_month = [];
      _.each(_.keys(users_data2), function(date) {
        curr_month.push(
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
            date.slice(6, 8)
        );
      });
      return curr_month;
    };
    get_previous_months = function(users_data1) {
      prev_month = [];
      _.each(_.keys(users_data1), function(date) {
        prev_month.push(
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
            date.slice(6, 8)
        );
      });
      return prev_month;
    };
    /////////////////
    HubCharts.visitors_pie_chart_data = function(ga_data) {
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
          height: 280
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
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        legend: {
          align: 'left',
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

    HubCharts.contacts_per_day = function(contacts_data) {
      var starting_date = Object.keys(contacts_data)[0];
      return {
        chart: {
          type: 'column',
          height: 400
        },
        title: {
          text: ''
        },
        navigation: {
          buttonOptions: {
            enabled: false
          }
        },
        xAxis: {
          categories: Object.keys(contacts_data),
          labels: {
            formatter: function() {
              return moment(this.value.toString()).format('MMM D');
            }
          }
        },
        yAxis: {
          labels: {
            enabled: false
          },
          gridLineWidth: 0,
          title: {
            text: ''
          },
          allowDecimals: false
        },
        plotOptions: {
          series: {
            pointWidth: 10
          },
          column: {
            dataLabels: {
              enabled: true,
              color: 'grey'
            }
          }
        },
        tooltip: {
          shared: true,
          valueSuffix: ''
        },
        credits: {
          enabled: false
        },
        series: [
          {
            name: 'Number of Contacts',
            data: Object.values(contacts_data)
          }
        ]
      };
    };
    return HubCharts;
  }
]);
