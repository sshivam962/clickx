var FbadsChart = {
  get_line_chart_config: function () {
    return {
      chart_config: {
        type: 'column',
        backgroundColor: '#fff',
        height: 350,
        spacingTop: 20,
      },
    };
  },

  users_chart: function (users_data) {
    curr_month = FbAdsUtils.get_month_names(users_data);
    var fbads_clicks = [];
    var fbads_impressions = [];
    var fbads_cpc = [];

    _.each(_.values(users_data), function (insight) {
      fbads_clicks.push(parseInt(insight.clicks));
      fbads_impressions.push(parseInt(insight.impressions));
      fbads_cpc.push(parseInt(insight.cpc));
    });

    return [
      FbAdsUtils.clicks_chart_data(curr_month, fbads_clicks),
      FbAdsUtils.impressions_chart_data(curr_month, fbads_impressions),
      FbAdsUtils.cpc_chart_data(curr_month, fbads_cpc),
    ];
  },
};

var FbAdsUtils = {
  clicks_chart_data: function (curr_month, data) {
    return {
      chart: FbadsChart.get_line_chart_config().chart_config,
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
            this.x +
            '<br><b>Clicks : ' +
            this.y
              .toFixed(2)
              .toString()
              .split('.')[0]
              .replace(/\B(?=(\d{3})+(?!\d))/g, ',') +
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
      credits: { enabled: false },
    };
  },

  impressions_chart_data: function (curr_month, data) {
    return {
      chart: FbadsChart.get_line_chart_config().chart_config,
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
            this.x +
            '<br><b>Impressions : ' +
            this.y
              .toFixed(2)
              .toString()
              .split('.')[0]
              .replace(/\B(?=(\d{3})+(?!\d))/g, ',') +
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
      credits: { enabled: false },
    };
  },

  cpc_chart_data: function (curr_month, data) {
    return {
      chart: FbadsChart.get_line_chart_config().chart_config,
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
            this.x +
            '<br><b>CPC : ' +
            this.y
              .toFixed(2)
              .toString()
              .split('.')[0]
              .replace(/\B(?=(\d{3})+(?!\d))/g, ',') +
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
      credits: { enabled: false },
    };
  },

  get_month_names: function (graph_data) {
    month_namesFBAds = [];
    dates = _.pluck(graph_data, 'date_start');
    _.each(dates, function (month_date) {
      var short_month = FbAdsUtils.get_month_short_name(month_date);
      month_namesFBAds.push(short_month + ' ' + month_date.slice(8, 10));
    });
    return month_namesFBAds;
  },

  get_month_short_name: function (date) {
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
    return monthNames[parseInt(date.split('-')[1])].substr(0, 3);
  },
};
