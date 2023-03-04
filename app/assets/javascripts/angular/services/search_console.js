clickxApp.factory('SearchConsole', [
  'MonthNames',
  function(MonthNames) {
    var SearchConsole = {};

    SearchConsole.modify_data_for_view = function(table_data) {
      _.each(table_data.rows, function(row) {
        row['keys'] = row['keys'][0];
        row['ctr'] = row['ctr'];
        row['position'] = row['position'];
      });
      return table_data;
    };

    SearchConsole.get_datewise_graph = function(graph_data) {
      data = SearchConsole.modify_data_for_view(graph_data);
      month_names_insearch = get_month_names_insearch(graph_data);
      clicks = _.pluck(graph_data.rows, 'clicks');
      ctr = _.pluck(graph_data.rows, 'ctr');
      impressions = _.pluck(graph_data.rows, 'impressions');
      position = _.pluck(graph_data.rows, 'position');

      chart_data = [];
      chart_data['clicks'] = search_console_date_graph(
        clicks,
        month_names_insearch
      );
      chart_data['ctr'] = search_console_date_graph(ctr, month_names_insearch);
      chart_data['impressions'] = search_console_date_graph(
        impressions,
        month_names_insearch
      );
      chart_data['position'] = search_console_date_graph(
        position,
        month_names_insearch
      );
      return chart_data;
    };

    search_console_date_graph = function(data, month_names_insearch) {
      chart_config = {
        backgroundColor: '#fff',
        height: 250,
        width: 1145,
        spacingTop: 20,
        spacingBottom: 25
      };
      return {
        chart: chart_config,
        title: { text: '' },
        xAxis: {
          categories: month_names_insearch
        },
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
            enabled: false
          }
        },
        tooltip: {
          formatter: function() {
            var date = new Date(null);
            date.setSeconds(this.y);
            return this.x + '<br> ' + Math.round(this.y * 100) / 100;
          }
        },
        series: [
          {
            showInLegend: false, // dont show name of graph
            data: data,
            color: '#f1ca3a'
          }
        ],
        credits: { enabled: false }
      };
    };

    get_month_names_insearch = function(data) {
      month_names_insearch = [];
      _.each(data.rows, function(fields) {
        month_date = fields.keys;
        var short_month = MonthNames.getShortMonthName(month_date);
        month_names_insearch.push(short_month + month_date.slice(8, 10));
      });
      return month_names_insearch;
    };

    return SearchConsole;
  }
]);
