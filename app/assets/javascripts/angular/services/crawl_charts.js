clickxApp.factory('CrawlCharts', [
  'MonthNames',
  function(MonthNames) {
    var CrawlCharts = {};

    CrawlCharts.date_wise_errors_graph = function(data, current_client) {
      // get errors for only current client
      client_errors = _.where(data, { platform: current_client });
      // keep only selected error types
      error_types = ['serverError', 'soft404', 'authPermissions', 'notFound'];
      client_errors = _.reject(client_errors, function(row) {
        return _.contains(error_types, row.category) == false;
      });

      // sort errors as per the types
      // this will give us hash like {error_type: array of errors}
      client_errors = _.groupBy(client_errors, 'category');
      client_errors = _.mapObject(client_errors, function(val, key) {
        return val[0].entries;
      });
      graph_data = {};
      _.each(client_errors, function(row, type) {
        month_names = [];
        counts = [];
        _.each(row, function(data) {
          counts.push(parseInt(data.count));
          month_names.push(moment(data.timestamp).format('MM/DD/YY'));
        });
        graph_data[type] = error_graph(counts, month_names);
      });
      return graph_data;
    };

    error_graph = function(counts, month_names) {
      return {
        chart: {
          backgroundColor: '#fff',
          spacingTop: 20
        },
        title: {
          text: ''
        },
        xAxis: {
          categories: month_names
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
        series: [
          {
            name: 'Errors: ',
            data: counts,
            color: '#f1ca3a'
          }
        ],
        credits: { enabled: false }
      };
    };

    CrawlCharts.all_sitemaps = function(data) {
      web_data = [];
      img_data = [];
      // get only data needed as per type
      _.each(data, function(row) {
        web_data.push(
          _.find(row.contents, function(rw) {
            return rw.type == 'web';
          })
        );
        img_data.push(
          _.find(row.contents, function(rw) {
            return rw.type == 'image';
          })
        );
      });

      // geenerate series by combining multiple rows reveived
      web_series = { submitted: 0, indexed: 0 };
      img_series = { submitted: 0, indexed: 0 };
      _.each(web_data, function(row) {
        if(row && !row.isPending){
          web_series.submitted += 1
        }
        if(row && row.isSitemapsIndex){
          web_series.indexed += 1
        }
      });
      _.each(img_data, function(row) {
        if(row && !row.isPending){
          img_series.submitted += 1
        }
        if(row && row.isSitemapsIndex){
          img_series.indexed += 1
        }
      });

      // get graph data
      graph = bar_graph(web_series, img_series);
      return graph;
    };

    bar_graph = function(web_data, img_data) {
      var categories = ['Web', 'Images'];
      var bar_colors = ['#4d90fe', '#dd4b39'];
      var data = { Web: [], Images: [] };
      series = [];
      series.push({
        name: 'Submitted',
        data: [web_data.submitted, img_data.submitted]
      });
      series.push({
        name: 'Indexed',
        data: [web_data.indexed, img_data.indexed]
      });

      return {
        chart: {
          type: 'column',
          events: {
            load: function() {
              var chart = this;
              setTimeout(function() {
                chart.reflow();
              }, 10);
            }
          }
        },
        title: { text: '' },
        xAxis: { categories: categories },
        yAxis: {
          min: 0,
          title: { text: '' },
          stackLabels: { style: { colors: bar_colors } }
        },
        tooltip: {
          backgroundColor: '#fff',
          borderColor: 'black',
          borderWidth: 1,
          borderRadius: 12
        },
        legend: {},
        series: series,
        plotOptions: {},
        colors: bar_colors,
        credits: { enabled: false }
      };
    }; // end of google_ranking_data

    return CrawlCharts;
  }
]);
