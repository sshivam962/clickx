var GoogleAnalytics = {
  generic_pie_chart_data: function (ga_data) {
    total_sum = _.reduce(
      [
        ga_data.referral,
        ga_data.organic,
        ga_data.paid,
        ga_data.direct,
        ga_data.social,
        ga_data.email,
        ga_data.others,
      ],
      function (memo, num) {
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
        height: 140,
      },
      exporting: {
        enabled: false,
      },
      title: {
        text: '',
      },
      tooltip: {
        pointFormat: '{point.percentage:.1f}%</b>',
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: false,
          },
          showInLegend: true,
        },
        series: {
          point: {
            events: {
              legendItemClick: function () {
                return false;
              },
            },
          },
        },
      },
      legend: {
        align: 'right',
        layout: 'vertical',
        verticalAlign: 'top',
        x: 20,
        y: 5,
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
            ['(Others)', (ga_data.others / total_sum) * 100],
          ],
        },
      ],
      credits: {
        enabled: false,
      },
    };
  },
  users_chart: function (users_data, graph_option) {
    curr_month = GoogleAnalyticsUtils.get_current_month_with_graph_option(
      users_data,
      graph_option
    );
    visits_data = [];
    visitors_data = [];
    page_visits = [];
    bounce_data = [];
    avg_session_data = [];
    avg_session_durations = [];
    session_conv_rate_data = [];
    page_per_visit_data = [];
    _.each(_.values(users_data), function (data) {
      visits_data.push(data[0]);
      visitors_data.push(data[1]);
      page_per_visit_data.push(data[2]);
      avg_session_durations.push(data[3]);
      session_conv_rate_data.push(data[4]);
      bounce_data.push(data[5]);
    });
    return [
      GoogleAnalyticsUtils.visits_chart_data(curr_month, visits_data),
      GoogleAnalyticsUtils.visitor_chart_data(curr_month, visitors_data),
      GoogleAnalyticsUtils.page_per_visit_chart_data(
        curr_month,
        page_per_visit_data
      ),
      GoogleAnalyticsUtils.avg_session_chart_data(
        curr_month,
        avg_session_durations,
        ''
      ),
      GoogleAnalyticsUtils.new_visit_chart_data(
        curr_month,
        session_conv_rate_data
      ),
      GoogleAnalyticsUtils.bounce_chart_data(
        curr_month,
        bounce_data,
        graph_option
      ),
    ];
  },
};

var GoogleAnalyticsUtils = {
  avg_session_chart_data: function (curr_month, data, durations) {
    return {
      chart: GoogleAnalyticsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: curr_month,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
      ],
      yAxis: {
        plotLines: [
          {
            value: 0,
            width: 1,
            color: '#808080',
          },
        ],
        min: 0,
      },
      navigation: {
        buttonOptions: {
          align: 'left',
        },
      },
      tooltip: {
        formatter: function () {
          var date = new Date(null);
          date.setSeconds(this.y);
          return (
            this.x +
            '<br><b>Avg. Time on Site : ' +
            date.toISOString().substr(11, 8) +
            '</b>'
          );
        },
      },
      series: [
        {
          name: 'Current Period',
          data: data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        area: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: {
        enabled: false,
      },
    };
  },

  visits_chart_data: function (curr_month, data) {
    return {
      chart: GoogleAnalyticsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: curr_month,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
      ],
      yAxis: {
        plotLines: [
          {
            value: 0,
            width: 1,
            color: '#808080',
          },
        ],
        min: 0,
      },
      navigation: {
        buttonOptions: {
          align: 'left',
        },
      },
      tooltip: {
        formatter: function () {
          return this.x + '<br><b>Visits : ' + this.y + '</b>';
        },
      },
      series: [
        {
          name: 'Current Period',
          data: data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        area: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: {
        enabled: false,
      },
    };
  },

  visitor_chart_data: function (curr_month, data) {
    return {
      chart: GoogleAnalyticsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: curr_month,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
      ],
      yAxis: {
        plotLines: [
          {
            value: 0,
            width: 1,
            color: '#808080',
          },
        ],
        min: 0,
      },
      navigation: {
        buttonOptions: {
          align: 'left',
        },
      },
      tooltip: {
        formatter: function () {
          return this.x + '<br><b>Visitors : ' + this.y + '</b>';
        },
      },
      series: [
        {
          name: 'Current Period',
          data: data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        area: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: {
        enabled: false,
      },
    };
  },

  page_per_visit_chart_data: function (curr_month, data) {
    return {
      chart: GoogleAnalyticsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: curr_month,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
      ],
      yAxis: {
        plotLines: [
          {
            value: 0,
            width: 1,
            color: '#808080',
          },
        ],
        min: 0,
      },
      navigation: {
        buttonOptions: {
          align: 'left',
        },
      },
      tooltip: {
        formatter: function () {
          return this.x + '<br><b>Page/Visit : ' + this.y.toFixed(2) + '</b>';
        },
      },
      series: [
        {
          name: 'Current Period',
          data: data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        area: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: {
        enabled: false,
      },
    };
  },

  bounce_chart_data: function (curr_month, data, graph_option) {
    if (graph_option == 'month' || graph_option == 'year') {
      return {
        chart: GoogleAnalyticsUtils.get_column_chart_config().chart_config,
        title: {
          text: '',
        },
        bars: 'vertical',
        xAxis: [
          {
            categories: curr_month,
          },
        ],
        yAxis: {
          min: 0,
        },
        navigation: {
          buttonOptions: {
            align: 'left',
          },
        },
        tooltip: {
          formatter: function () {
            return (
              this.x + '<br><b>Bounce Rate : ' + this.y.toFixed(2) + '%</b>'
            );
          },
          trigger: 'focus',
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80',
          },
        ],
        plotOptions: {
          bar: {
            dataLabels: {
              enabled: true,
            },
          },
        },
        credits: {
          enabled: false,
        },
      };
    } else {
      return {
        chart: GoogleAnalyticsUtils.get_line_chart_config().chart_config,
        title: {
          text: '',
        },
        xAxis: [
          {
            categories: curr_month,
            lineColor: '#ffaa80',
            lineWidth: 3,
            tickColor: '#ffaa80',
            tickWidth: 3,
          },
        ],
        yAxis: {
          plotLines: [
            {
              value: 0,
              width: 1,
              color: '#808080',
            },
          ],
          min: 0,
        },
        navigation: {
          buttonOptions: {
            align: 'left',
          },
        },
        tooltip: {
          formatter: function () {
            return (
              this.x + '<br><b>Bounce Rate : ' + this.y.toFixed(2) + '%</b>'
            );
          },
        },
        series: [
          {
            name: 'Current Period',
            data: data,
            color: '#ffccb3',
            lineColor: '#ffaa80',
          },
        ],
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            marker: {
              enabled: false,
            },
          },
        },
        credits: {
          enabled: false,
        },
      };
    }
  },

  new_visit_chart_data: function (curr_month, data) {
    return {
      chart: GoogleAnalyticsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: curr_month,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
      ],
      yAxis: {
        plotLines: [
          {
            value: 0,
            width: 1,
            color: '#808080',
          },
        ],
        min: 0,
      },
      navigation: {
        buttonOptions: {
          align: 'left',
        },
      },
      tooltip: {
        formatter: function () {
          return (
            this.x + '<br><b>Conversion Rate : ' + this.y.toFixed(2) + '</b>'
          );
        },
      },
      series: [
        {
          name: 'Current Period',
          data: data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        area: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: {
        enabled: false,
      },
    };
  },

  get_current_month_with_graph_option: function (data, graph_option) {
    if (graph_option == 'date' || graph_option == 'week') {
      return GoogleAnalyticsUtils.get_current_month(data);
    } else {
      return _.map(_.keys(data), function (date) {
        return (
          GoogleAnalyticsUtils.getShortMonthName(
            [
              date.slice(0, 4),
              '-',
              date.slice(4, 6),
              '-',
              date.slice(6, 8),
            ].join('')
          ) +
          '. ' +
          date.slice(0, 4)
        );
      });
    }
  },

  getShortMonthName: function (dates) {
    var monthNames = [
      0,
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[parseInt(dates.split('-')[1])].substr(0, 3);
  },

  get_current_month: function (data) {
    return _.map(_.keys(data), function (date) {
      return (
        GoogleAnalyticsUtils.getShortMonthName(
          [date.slice(0, 4), '-', date.slice(4, 6), '-', date.slice(6, 8)].join(
            ''
          )
        ) +
        '. ' +
        date.slice(6, 8) +
        '. ' +
        date.slice(0, 4)
      );
    });
  },

  get_line_chart_config: function () {
    return {
      chart_config: {
        type: 'area',
        backgroundColor: '#fff',
        height: 350,
        spacingTop: 20,
      },
    };
  },

  get_column_chart_config: function () {
    return {
      chart_config: {
        type: 'column',
        backgroundColor: '#fff',
        height: 350,
        spacingTop: 20,
      },
    };
  },
};
