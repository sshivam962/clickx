var GoogleAds = {
  performance: function (this_period, last_period) {
    month_namesAdwords_this_period =
      GoogleAdsUtils.get_month_namesAdwords(this_period);
    month_namesAdwords_last_period =
      GoogleAdsUtils.get_month_namesAdwords(last_period);

    this_period_clicks_data = _.pluck(this_period, 'interactions');
    last_period_clicks_data = _.pluck(last_period, 'interactions');
    this_period_impressions_data = _.pluck(this_period, 'impressions');
    last_period_impressions_data = _.pluck(last_period, 'impressions');
    this_period_cost_data = _.map(_.pluck(this_period, 'cost'), function (n) {
      if (n != null) {
        return Number((n / 1000000).toFixed(2));
      } else return null;
    });
    last_period_cost_data = _.map(_.pluck(last_period, 'cost'), function (n) {
      if (n != null) {
        return Number((n / 1000000).toFixed(2));
      } else return null;
    });
    this_period_avg_cost_data = _.map(
      _.pluck(this_period, 'avg_cost'),
      function (n) {
        if (n != null) {
          return Number((n / 1000000).toFixed(2));
        } else return null;
      }
    );
    last_period_avg_cost_data = _.map(
      _.pluck(last_period, 'avg_cost'),
      function (n) {
        if (n != null) {
          return Number((n / 1000000).toFixed(2));
        } else return null;
      }
    );
    this_period_ctr_data = _.pluck(this_period, 'ctr');
    last_period_ctr_data = _.pluck(last_period, 'ctr');
    this_period_conversions_data = _.pluck(this_period, 'conversions');
    last_period_conversions_data = _.pluck(last_period, 'conversions');

    return [
      GoogleAdsUtils.clicks_perfomance_chart(
        this_period_clicks_data,
        last_period_clicks_data,
        month_namesAdwords_this_period,
        month_namesAdwords_last_period
      ),
      GoogleAdsUtils.impressions_perfomance_chart(
        this_period_impressions_data,
        last_period_impressions_data,
        month_namesAdwords_this_period,
        month_namesAdwords_last_period
      ),
      GoogleAdsUtils.cost_perfomance_chart(
        this_period_cost_data,
        last_period_cost_data,
        month_namesAdwords_this_period,
        month_namesAdwords_last_period
      ),
      GoogleAdsUtils.avg_cost_perfomance_chart(
        this_period_avg_cost_data,
        last_period_avg_cost_data,
        month_namesAdwords_this_period,
        month_namesAdwords_last_period
      ),
      GoogleAdsUtils.ctr_perfomance_chart(
        this_period_ctr_data,
        last_period_ctr_data,
        month_namesAdwords_this_period,
        month_namesAdwords_last_period
      ),
      GoogleAdsUtils.conversions_perfomance_chart(
        this_period_conversions_data,
        last_period_conversions_data,
        month_namesAdwords_this_period,
        month_namesAdwords_last_period
      ),
    ];
  },
};

var GoogleAdsUtils = {
  avg_cost_perfomance_chart: function (
    this_period_avg_cost_data,
    last_period_avg_cost_data,
    month_namesAdwords_this_period,
    month_namesAdwords_last_period
  ) {
    return {
      chart: GoogleAdsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: month_namesAdwords_this_period,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
        {
          categories: month_namesAdwords_last_period,
          opposite: true,
          lineColor: '#b3cccc',
          lineWidth: 3,
          tickColor: '#b3cccc',
          tickWidth: 3,
        },
      ],
      yAxis: {
        min: 0,
      },
      navigation: {
        buttonOptions: {
          enabled: false,
        },
      },
      tooltip: {
        formatter: function () {
          return (
            this.x +
            ' ' +
            '<br>' +
            this.series.name +
            ': ' +
            '<strong>' +
            this.y.toFixed(2) +
            '</strong>'
          );
        },
      },
      series: [
        {
          name: 'Previous Period',
          data: last_period_avg_cost_data,
          color: '#d1e0e0',
          lineColor: '#b3cccc',
          xAxis: 1,
        },
        {
          name: 'Current Period',
          data: this_period_avg_cost_data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: { enabled: false },
    };
  },

  ctr_perfomance_chart: function (
    this_period_ctr_data,
    last_period_ctr_data,
    month_namesAdwords_this_period,
    month_namesAdwords_last_period
  ) {
    return {
      chart: GoogleAdsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: month_namesAdwords_this_period,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
        {
          categories: month_namesAdwords_last_period,
          opposite: true,
          lineColor: '#b3cccc',
          lineWidth: 3,
          tickColor: '#b3cccc',
          tickWidth: 3,
        },
      ],
      yAxis: {
        min: 0,
      },
      navigation: {
        buttonOptions: {
          enabled: false,
        },
      },
      tooltip: {
        formatter: function () {
          return (
            this.x +
            ' ' +
            '<br>' +
            this.series.name +
            ': ' +
            '<strong>' +
            this.y.toFixed(2) +
            '</strong>'
          );
        },
      },
      series: [
        {
          name: 'Previous Period',
          data: last_period_ctr_data,
          color: '#d1e0e0',
          lineColor: '#b3cccc',
          xAxis: 1,
        },
        {
          name: 'Current Period',
          data: this_period_ctr_data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: { enabled: false },
    };
  },

  clicks_perfomance_chart: function (
    this_period_clicks_data,
    last_period_clicks_data,
    month_namesAdwords_this_period,
    month_namesAdwords_last_period
  ) {
    return {
      chart: GoogleAdsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: month_namesAdwords_this_period,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
        {
          categories: month_namesAdwords_last_period,
          opposite: true,
          lineColor: '#b3cccc',
          lineWidth: 3,
          tickColor: '#b3cccc',
          tickWidth: 3,
        },
      ],
      yAxis: {
        min: 0,
      },
      navigation: {
        buttonOptions: {
          enabled: false,
        },
      },
      tooltip: {
        formatter: function () {
          return (
            this.x +
            ' ' +
            '<br>' +
            this.series.name +
            ': ' +
            '<strong>' +
            this.y +
            '</strong>'
          );
        },
      },
      series: [
        {
          name: 'Previous Period',
          data: last_period_clicks_data,
          color: '#d1e0e0',
          lineColor: '#b3cccc',
          xAxis: 1,
        },
        {
          name: 'Current Period',
          data: this_period_clicks_data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: { enabled: false },
    };
  },

  impressions_perfomance_chart: function (
    this_period_impressions_data,
    last_period_impressions_data,
    month_namesAdwords_this_period,
    month_namesAdwords_last_period
  ) {
    return {
      chart: GoogleAdsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: month_namesAdwords_this_period,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
        {
          categories: month_namesAdwords_last_period,
          opposite: true,
          lineColor: '#b3cccc',
          lineWidth: 3,
          tickColor: '#b3cccc',
          tickWidth: 3,
        },
      ],
      yAxis: {
        min: 0,
      },
      navigation: {
        buttonOptions: {
          enabled: false,
        },
      },
      tooltip: {
        formatter: function () {
          return (
            this.x +
            ' ' +
            '<br>' +
            this.series.name +
            ': ' +
            '<strong>' +
            this.y +
            '</strong>'
          );
        },
      },

      series: [
        {
          name: 'Previous Period ',
          data: last_period_impressions_data,
          color: '#d1e0e0',
          lineColor: '#b3cccc',
          xAxis: 1,
        },
        {
          name: 'Current Period',
          data: this_period_impressions_data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: { enabled: false },
    };
  },

  conversions_perfomance_chart: function (
    this_period_conversions_data,
    last_period_conversions_data,
    month_namesAdwords_this_period,
    month_namesAdwords_last_period
  ) {
    return {
      chart: GoogleAdsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: month_namesAdwords_this_period,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
        {
          categories: month_namesAdwords_last_period,
          opposite: true,
          lineColor: '#b3cccc',
          lineWidth: 3,
          tickColor: '#b3cccc',
          tickWidth: 3,
        },
      ],
      yAxis: {
        min: 0,
      },
      navigation: {
        buttonOptions: {
          enabled: false,
        },
      },
      tooltip: {
        formatter: function () {
          return (
            this.x +
            ' ' +
            '<br>' +
            this.series.name +
            ': ' +
            '<strong>' +
            this.y.toFixed(2) +
            '</strong>'
          );
        },
      },
      series: [
        {
          name: 'Previous Period',
          data: last_period_conversions_data,
          color: '#d1e0e0',
          lineColor: '#b3cccc',
          xAxis: 1,
        },
        {
          name: 'Current Period',
          data: this_period_conversions_data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: { enabled: false },
    };
  },

  cost_perfomance_chart: function (
    this_period_cost_data,
    last_period_cost_data,
    month_namesAdwords_this_period,
    month_namesAdwords_last_period
  ) {
    return {
      chart: GoogleAdsUtils.get_line_chart_config().chart_config,
      title: {
        text: '',
      },
      xAxis: [
        {
          categories: month_namesAdwords_this_period,
          lineColor: '#ffaa80',
          lineWidth: 3,
          tickColor: '#ffaa80',
          tickWidth: 3,
        },
        {
          categories: month_namesAdwords_last_period,
          opposite: true,
          lineColor: '#b3cccc',
          lineWidth: 3,
          tickColor: '#b3cccc',
          tickWidth: 3,
        },
      ],
      yAxis: {
        min: 0,
      },
      navigation: {
        buttonOptions: {
          enabled: false,
        },
      },
      tooltip: {
        formatter: function () {
          return (
            this.x +
            ' ' +
            '<br>' +
            this.series.name +
            ': ' +
            '<strong>' +
            this.y.toFixed(2) +
            '</strong>'
          );
        },
      },
      series: [
        {
          name: 'Previous Period',
          data: last_period_cost_data,
          color: '#d1e0e0',
          lineColor: '#b3cccc',
          xAxis: 1,
        },
        {
          name: 'Current Period',
          data: this_period_cost_data,
          color: '#ffccb3',
          lineColor: '#ffaa80',
        },
      ],
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5,
          marker: {
            enabled: false,
          },
        },
      },
      credits: { enabled: false },
    };
  },

  get_month_namesAdwords: function (dates) {
    month_namesAdwords = [];
    _.each(_.keys(dates), function (month_date) {
      var short_month = GoogleAdsUtils.getShortMonthName(month_date);
      month_namesAdwords.push(short_month + month_date.slice(8, 10));
    });
    return month_namesAdwords;
  },

  get_line_chart_config: function () {
    return {
      chart_config: {
        type: 'area',
        backgroundColor: '#fff',
        height: 350,
        width: 1145,
        spacingTop: 20,
      },
    };
  },

  getShortMonthName: function (date) {
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
