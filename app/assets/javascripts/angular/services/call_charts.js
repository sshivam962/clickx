clickxApp.factory('CallCharts', [
  'MonthNames',
  function(MonthNames) {
    var CallCharts = {};

    CallCharts.call_status_pie_chart_data = function(status_data) {
      return {
        chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          backgroundColor: '#fff',
          height: 200
        },
        exporting: { enabled: false },
        title: { text: '' },
        tooltip: {
          formatter: function() {
            return this.y;
          }
        },
        plotOptions: {
          pie: {
            size: 100,
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
          align: 'center',
          layout: 'horizontal',
          verticalAlign: 'bottom',
          x: 20,
          y: 10,
          labelFormatter: function() {
            return this.name + '  ' + this.y;
          }
        },
        series: [
          {
            type: 'pie',
            name: 'Calls_By_Status',
            data: [
              ['Answers', status_data.ANSWER || 0],
              ['No Answer', status_data.NOANSWER || 0],
              ['Cancel', status_data.CANCEL || 0]
            ]
          }
        ],
        credits: { enabled: false }
      };
    };

    CallCharts.unique_calls_bar_chart_data = function(
      unique_calls_data,
      greater_than_five
    ) {
      return {
        chart: {
          type: 'column',
          height: 200
        },
        exporting: { enabled: false },
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
            '<tr><td style="color:{series.color};padding:0">Times Called: </td>' +
            '<td style="padding:0"><b>{point.y} calls</b></td></tr>',
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
        credits: { enabled: false }
      };
    };

    CallCharts.leads_bar_chart_data = function(leads_data) {
      month_names = [];
      //calculate short month name
      _.each(_.keys(leads_data), function(month_date) {
        var short_month = MonthNames.getShortMonthName(month_date);
        month_names.push(short_month + month_date.slice(8, 10));
      });

      unique_calls_data = [];
      repetative_calls_data = [];

      //seperating unique and repetative data
      _.each(_.values(leads_data), function(data) {
        unique_calls_data.push(data[0] || 0);
        repetative_calls_data.push(data[1] || 0);
      });

      return {
        chart: {
          type: 'column',
          height: 300,
          width: 1000
        },
        exporting: { enabled: false },
        title: {
          text: ''
        },
        xAxis: {
          categories: month_names,
          reversed: true
        },
        yAxis: {
          min: 0,
          title: {
            text: 'Calls'
          },
          stackLabels: {
            enabled: true,
            style: {
              fontWeight: 'bold',
              color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
            }
          }
        },
        legend: {
          align: 'center',
          verticalAlign: 'bottom',
          x: 20,
          y: 15,
          backgroundColor:
            (Highcharts.theme && Highcharts.theme.background2) || 'white',
          borderColor: '#CCC',
          borderWidth: 1,
          shadow: false
        },
        tooltip: {
          headerFormat: '<b>{point.x}</b><br/>',
          pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
        },
        plotOptions: {
          column: {
            stacking: 'normal',
            dataLabels: {
              enabled: true,
              color:
                (Highcharts.theme && Highcharts.theme.dataLabelsColor) ||
                'white',
              style: {
                textShadow: '0 0 3px black'
              }
            }
          }
        },
        series: [
          {
            name: 'Unique Leads',
            data: unique_calls_data
          },
          {
            name: 'Repeat Callers',
            data: repetative_calls_data
          }
        ],
        credits: { enabled: false }
      };
    };
    return CallCharts;
  }
]);
