var SearchConsole = {
  get_datewise_graph: function (graph_data) {
    data = SearchConsoleUtils.modify_data_for_view(graph_data);
    month_names = SearchConsoleUtils.get_month_names(graph_data);
    clicks = _.pluck(graph_data.rows, 'clicks');
    ctr = _.pluck(graph_data.rows, 'ctr');
    impressions = _.pluck(graph_data.rows, 'impressions');
    position = _.pluck(graph_data.rows, 'position');

    chart_data = [];
    chart_data['clicks'] = SearchConsoleUtils.search_console_date_graph(
      clicks,
      month_names
    );
    chart_data['ctr'] = SearchConsoleUtils.search_console_date_graph(
      ctr,
      month_names
    );
    chart_data['impressions'] = SearchConsoleUtils.search_console_date_graph(
      impressions,
      month_names
    );
    chart_data['position'] = SearchConsoleUtils.search_console_date_graph(
      position,
      month_names
    );
    return chart_data;
  },

  all_sitemaps: function (data) {
    web_data = [];
    img_data = [];
    // get only data needed as per type
    _.each(data, function (row) {
      web_data.push(
        _.find(row.contents, function (rw) {
          return rw.type == 'web';
        })
      );
      img_data.push(
        _.find(row.contents, function (rw) {
          return rw.type == 'image';
        })
      );
    });

    // geenerate series by combining multiple rows reveived
    web_series = { submitted: 0, indexed: 0 };
    img_series = { submitted: 0, indexed: 0 };
    _.each(web_data, function (row) {
      if (row && !row.isPending) {
        web_series.submitted += 1;
      }
      if (row && row.isSitemapsIndex) {
        web_series.indexed += 1;
      }
    });
    _.each(img_data, function (row) {
      if (row && !row.isPending) {
        img_series.submitted += 1;
      }
      if (row && row.isSitemapsIndex) {
        img_series.indexed += 1;
      }
    });

    // get graph data
    graph = SearchConsoleUtils.bar_graph(web_series, img_series);
    return graph;
  },
};

var SearchConsoleUtils = {
  modify_data_for_view: function (table_data) {
    _.each(table_data.rows, function (row) {
      row['keys'] = row['keys'][0];
      row['ctr'] = row['ctr'];
      row['position'] = row['position'];
    });
    return table_data;
  },
  bar_graph: function (web_data, img_data) {
    var categories = ['Web', 'Images'];
    var bar_colors = ['#4d90fe', '#dd4b39'];
    var data = { Web: [], Images: [] };
    series = [];
    series.push({
      name: 'Submitted',
      data: [web_data.submitted, img_data.submitted],
    });
    series.push({
      name: 'Indexed',
      data: [web_data.indexed, img_data.indexed],
    });

    return {
      chart: {
        type: 'column',
        events: {
          load: function () {
            var chart = this;
            setTimeout(function () {
              chart.reflow();
            }, 10);
          },
        },
      },
      title: { text: '' },
      xAxis: { categories: categories },
      yAxis: {
        min: 0,
        title: { text: '' },
        stackLabels: { style: { colors: bar_colors } },
      },
      tooltip: {
        backgroundColor: '#fff',
        borderColor: 'black',
        borderWidth: 1,
        borderRadius: 12,
      },
      legend: {},
      series: series,
      plotOptions: {},
      colors: bar_colors,
      credits: { enabled: false },
    };
  },

  search_console_date_graph: function (data, month_names) {
    chart_config = {
      backgroundColor: '#fff',
      height: 250,
      width: 1145,
      spacingTop: 20,
      spacingBottom: 25,
    };
    return {
      chart: chart_config,
      title: { text: '' },
      xAxis: {
        categories: month_names,
      },
      yAxis: {
        plotLines: [
          {
            value: 0,
            width: 1,
            color: '#808080',
          },
        ],
      },
      navigation: {
        buttonOptions: {
          enabled: false,
        },
      },
      tooltip: {
        formatter: function () {
          var date = new Date(null);
          date.setSeconds(this.y);
          return this.x + '<br> ' + Math.round(this.y * 100) / 100;
        },
      },
      series: [
        {
          showInLegend: false, // dont show name of graph
          data: data,
          color: '#f1ca3a',
        },
      ],
      credits: { enabled: false },
    };
  },

  get_month_names: function (data) {
    month_names = [];
    _.each(data.rows, function (fields) {
      month_date = fields.keys;
      var short_month = SearchConsoleUtils.get_month_short_name(month_date);
      month_names.push(short_month + month_date.slice(8, 10));
    });
    return month_names;
  },

  get_month_short_name: function (dates) {
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
};
