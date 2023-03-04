clickxApp.service('SeoKeywordsChart', [
  '$rootScope',
  function($rootScope) {
    this.getKeyWordDataChart = function(
      allKeywordsDate,
      searchEngineData,
      animation
    ) {
      var animation = typeof animation != 'undefined' ? animation : true;
      var resultPlotDataOption = [];
      _.each(searchEngineData, function(value, index) {
        resultPlotDataOption.push({
          chart: {
            type: 'column',
            marginTop: 50,
            animation: animation
          },
          title: {
            align: 'center',
            text: ''
          },
          navigation: {
            buttonOptions: {
              enabled: false
            }
          },
          xAxis: {
            categories: allKeywordsDate
          },
          yAxis: {
            reversedStacks: true,
            min: 0,
            title: {
              text: 'Keywords'
            },
            stackLabels: {
              enabled: false,
              style: {
                fontWeight: 'bold',
                color:
                  (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
              }
            }
          },
          legend: {
            align: 'center',
            x: 0,
            verticalAlign: 'top',
            y: 0,
            floating: true,
            backgroundColor:
              (Highcharts.theme && Highcharts.theme.background2) || 'white',
            borderColor: '#CCC',
            borderWidth: 1,
            shadow: false,
            title: {
              text: 'Keyword Position'
            }
          },
          plotOptions: {
            column: {
              stacking: 'normal',
              animation: animation,
              dataLabels: {
                enabled: false,
                color:
                  (Highcharts.theme && Highcharts.theme.dataLabelsColor) ||
                  'white',
                style: {
                  textShadow: '0 0 3px black'
                }
              },
              tooltip: {
                followPointer: true,
                followTouchMove: true
              }
            },
            series: {
              cursor: 'pointer',
              point: {
                events: {
                  click: function($event) {
                    $rootScope.showModal(
                      this.category,
                      this.series.name,
                      $rootScope.timespan,
                      $event
                    );
                  }
                }
              }
            }
          },
          series: searchEngineData[index].reverse()
        });
      });

      return resultPlotDataOption;
    };

    this.processKeyWordData = function(result) {
      var resultData = result.row;
      var allKeywordsDate = [];
      var googleKeywords = [];
      var plotColor = [
        '#e3483d',
        '#ff7b27',
        '#ffd02b',
        '#7cb23f',
        '#378529',
        '#888888'
      ];
      var names = ['Above 50', '21-50', '11-20', '4-10', '1-3'];
      _.each(resultData, function(value, index) {
        try {
          allKeywordsDate.push(
            moment(value.date, 'YYYY-MM-DD').format("D MMM 'YY")
          );
          var googleData = value.rankingDistribution.googleRanking;
          var colorIndex = 0;
          for (var google in googleData) {
            var googleKeywordCheck = _.find(googleKeywords, function(value) {
              return value.name == names[google];
            });
            if (googleKeywordCheck) {
              _.each(googleKeywords, function(value, index) {
                if (value.name == names[google]) {
                  googleKeywords[index].data.push(googleData[google]);
                }
              });
            } else {
              var data = [googleData[google]];
              googleKeywords.push({
                name: names[google],
                data: data,
                color: plotColor[colorIndex]
              });
            }
            colorIndex++;
          }
          colorIndex = 0;
        } catch (er) {
          console.log(er);
          return {
            allKeywordsDate: [],
            searchEngineData: [[], []]
          };
        }
      });
      return {
        allKeywordsDate: allKeywordsDate,
        searchEngineData: [googleKeywords]
      };
    };
    this.keywordHistory = function(dates, rank, title) {
      return {
        chart: {
          type: 'spline'
        },
        title: {
          text: title
        },
        xAxis: {
          reversed: true,
          categories: dates
        },
        yAxis: {
          allowDecimals: false,
          reversed: true,
          title: {
            text: 'Rank'
          }
        },
        series: [
          {
            name: 'Rank',
            data: rank,
            showInLegend: false
          }
        ]
      };
    };
  }
]);
