clickxApp.factory('ReviewCharts', [
  'MonthNames',
  function(MonthNames) {
    var ReviewCharts = {};

    var colors = [
      '#c0392b',
      '#e74c3c',
      '#d35400',
      '#d35400',
      '#f39c12',
      '#f1c40f'
    ];

    ReviewCharts.ratings_bar_chart = function(ratings_data) {
      return {
        chart: {
          type: 'bar',
          marginTop: 50
        },
        title: {
          text: 'Reviews Chart'
        },
        subtitle: {
          text: ''
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
            distance: 15,
            formatter: function() {
              return {
                '5stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i>',
                '4stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star-o gold-star"></i>',
                '3stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i>',
                '2stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i>',
                '1stars':
                  '<i class="fa fa-star gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i>',
                '0stars':
                  '<i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i><i class="fa fa-star-o gold-star"></i>'
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
            pointWidth: 40
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

    return ReviewCharts;
  }
]);
