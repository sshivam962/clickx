clickxApp.factory('MonthNames', function() {
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
    'December'
  ];
  var MonthNames = {};

  MonthNames.getMonthName = function(date) {
    return monthNames[parseInt(date.split('-')[1])];
  };

  MonthNames.getShortMonthName = function(date) {
    return monthNames[parseInt(date.split('-')[1])].substr(0, 3);
  };

  MonthNames.getMonthNameByCase = function(date) {
    return monthNames[date].substr(0, 3);
  };

  return MonthNames;
});
