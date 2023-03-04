clickxApp.filter('joinByComma', function() {
  return function(input) {
    if (input == undefined) {
      return '';
    } else if (input.constructor === Array) {
      return input.join(', ');
    } else {
      return input;
    }
  };
});

clickxApp.filter('number_of_days', function() {
  return function(user_date) {
    var ONE_DAY = 1000 * 60 * 60 * 24;

    // Convert both dates to milliseconds
    user_date = new Date(user_date).getTime();
    var curr = new Date().getTime();

    // Calculate the difference in milliseconds
    var difference_ms = Math.abs(user_date - curr);

    // Convert back to days and return
    return Math.round(difference_ms / ONE_DAY);
  };
});

clickxApp.filter('full_name', function() {
  return function(user) {
    return [user.first_name, user.last_name].join(' ');
  };
});

clickxApp.filter('seoRankingChange', [
  '$sce',
  function($sce) {
    return function(changedVal) {
      if (changedVal == null) {
        // return if null
        return $sce.trustAsHtml('-');
      }
      changedVal = parseInt(changedVal);
      if (!_.isNumber(changedVal)) {
        // return if not number after parseInt
        return $sce.trustAsHtml('-');
      }
      if (changedVal == 0) {
        return $sce.trustAsHtml('-');
      } else if (changedVal > 0) {
        return $sce.trustAsHtml(
          "<span class='text-danger '><small><i class = 'fa fa-caret-down smaller-icon'></i></small> " +
            Math.abs(changedVal) +
            '</span>'
        );
      } else {
        return $sce.trustAsHtml(
          "<span class='text-success '><small><i class = 'fa fa-caret-up smaller-icon'></i></small> " +
            Math.abs(changedVal) +
            '</span>'
        );
      }
    };
  }
]);

clickxApp.filter('seoRankingPosition', [
  '$sce',
  function($sce) {
    return function(val) {
      if (val == 0 || val == undefined) {
        return $sce.trustAsHtml('<span class = grey>not found</span>');
      }
      if (val == '--') {
        return $sce.trustAsHtml('--');
      }
      if (val == '100+' || val == '50+') {
        return $sce.trustAsHtml(val);
      } // Remove th 50+ and 100+
      suffix =
        val < 11 || val > 13
          ? ['st', 'nd', 'rd', 'th'][Math.min((val - 1) % 10, 3)]
          : 'th';
      return $sce.trustAsHtml(val + '<sup>' + suffix + '</sup>');
    };
  }
]);

clickxApp.filter('seoLinkUrl', function() {
  return function(url) {
    if (url == null) {
      return '';
    }
    uri = new URL(url);
    view_val = uri.pathname.substring(0, 22);
    if (view_val == '/') {
      view_val = '[home page]';
    }
    return view_val;
  };
});

clickxApp.filter('commentHtmlSafe', [
  '$sce',
  function($sce) {
    return function(val) {
      return $sce.trustAsHtml(val);
    };
  }
]);

clickxApp.filter('fromnow', [
  '$sce',
  function($sce) {
    return function(input) {
      if (input != undefined) {
        suffix = moment().isDST() ? '-04:00' : '-05:00';
        val = input + suffix;
        return moment(val, 'YYYY-MM-DDTHH:mm:ssZ').fromNow();
      }
    };
  }
]);

clickxApp.filter('web_link', [
  '$sce',
  function ($sce) {
    return function (link) {
      if (link && link.indexOf('http') == -1) {
        link = 'http://' + link;
      }
      return link;
    };
  }
]);

clickxApp.filter('capitalize', [
  '$sce',
  function($sce) {
    return function(text) {
      return s.capitalize(text);
    };
  }
]);

/** Filter will return true or false according to the value, if undefined it will return true and if it not it will retrun false
 *  ng-show work it is true otherwise won't work
 *
 **/
clickxApp.filter('validateInput', function() {
  return function(input) {
    if (typeof input != 'undefined') {
      return false;
    } else {
      return true;
    }
  };
});

clickxApp.filter('range', function() {
  return function(val, range) {
    range = Math.round(parseFloat(range));
    for (var i = 0; i < range; i++) val.push(i);
    return val;
  };
});

clickxApp.filter('reviewStars', function() {
  return function(val, range) {
    val = ['fa-star-o', 'fa-star-o', 'fa-star-o', 'fa-star-o', 'fa-star-o'];
    range = Math.round(parseFloat(range));
    for (var i = 0; i < range; i++) val[i] = 'fa-star';
    return val;
  };
});

clickxApp.filter('capitalize', function() {
  return function(input) {
    return !!input
      ? input.charAt(0).toUpperCase() + input.substr(1).toLowerCase()
      : '';
  };
});

clickxApp.filter('mathABS', function() {
  return function(value) {
    return Math.abs(value);
  };
});

clickxApp.filter('tel', function() {
  return function(tel) {
    if (!tel) {
      return '';
    }

    var value = tel
      .toString()
      .trim()
      .replace(/^\+/, '');

    if (value.match(/[^0-9]/)) {
      return tel;
    }

    var country, city, number;

    switch (value.length) {
      case 10: // +1PPP####### -> C (PPP) ###-####
        country = 1;
        city = value.slice(0, 3);
        number = value.slice(3);
        break;

      case 11: // +CPPP####### -> CCC (PP) ###-####
        country = value[0];
        city = value.slice(1, 4);
        number = value.slice(4);
        break;

      case 12: // +CCCPP####### -> CCC (PP) ###-####
        country = value.slice(0, 3);
        city = value.slice(3, 5);
        number = value.slice(5);
        break;

      default:
        return tel;
    }

    if (country == 1) {
      country = '';
    }

    number = number.slice(0, 3) + '-' + number.slice(3);

    return (country + ' (' + city + ') ' + number).trim();
  };
});

clickxApp.filter('startAndEndDays', function() {
  'use strict';
  return function(input) {
    if (typeof input == 'undefined' || !_.isNumber(parseInt(input))) {
      return 'Unknown Days';
    }
    if (!moment(input, 'X').isValid()) {
      return 'Unknown Days';
    }
    var startWeekDay = moment(input, 'X')
      .startOf('week')
      .format('MMMM Do dddd');
    var endWeekDay = moment(input, 'X')
      .endOf('week')
      .format('MMMM Do dddd');

    return startWeekDay + '-' + endWeekDay;
  };
});

/* AGE FROM DATE */
clickxApp.filter('ageFromDate', [
  '$sce',
  function($sce) {
    'use strict';
    return function(input) {
      if (typeof input == 'undefined')
        return $sce.trustAsHtml(
          "<span class='editable editable-click editable-empty'></span>"
        );
      var dobDate = moment(input, 'YYYY-MM-DD').format();
      if (dobDate == 'Invalid date')
        return $sce.trustAsHtml(
          "<span class='editable editable-click editable-empty'></span>"
        );
      var dobArray = moment(dobDate).toArray();
      return $sce.trustAsHtml(
        '<span>(' + moment(dobArray).fromNow(true) + ')</span>'
      );
    };
  }
]);
/* FROM NOW */
clickxApp.filter('fromNowMoment', function() {
  'use strict';
  return function(input) {
    if (typeof input == 'undefined' || !moment(input).isValid())
      return 'Unknown';
    var gDate = moment(input).format();
    var dDateArray = moment(gDate).toArray();
    return moment(dDateArray).fromNow();
  };
});
/* US DATE FORMAT */
clickxApp.filter('usaDateFormat', [
  '$sce',
  function($sce) {
    'use strict';
    return function(input, prefix, suffix) {
      if (typeof prefix == 'undefined') prefix = '';
      if (typeof suffix == 'undefined') suffix = '';
      if (typeof input == 'undefined' || !moment(input).isValid())
        return $sce.trustAsHtml(
          "<span class='editable editable-click editable-empty'>Add Date of Birth</span>"
        );
      return $sce.trustAsHtml(
        '<span>' +
          prefix +
          moment(input).format('MM-DD-YYYY') +
          suffix +
          '</span>'
      );
    };
  }
]);

clickxApp.filter('fullName', function() {
  return function(user, dashboard) {
    if (user.fname && user.lname) return [user.fname, user.lname].join(' ');
    else if (dashboard) return user.phone || 'NA';
    else return 'NA';
  };
});

clickxApp.filter('decimalFilter', [
  '$filter',
  function($filter) {
    return function(input) {
      input = parseFloat(input);
      input = input.toFixed(input % 1 === 0 ? 0 : 2);
      return input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    };
  }
]);

clickxApp.filter('spaceBeforeCaps', function() {
  return function(input) {
    return input.replace(/([a-z])([A-Z])/g, '$1 $2');
  };
});

clickxApp.filter('toDollar', [
  '$filter',
  function($filter) {
    return function(input) {
      if (input != null) {
        input = parseFloat(input);
        input = input.toFixed(input % 1 === 0 ? 0 : 2);
        return '$' + input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      }else{
        return '-'
      }
    };
  }
]);

clickxApp.filter('toPercentage', [
  '$filter',
  function($filter) {
    return function(input) {
      if (input != null) {
        input = parseFloat(input);
        input = input.toFixed(input % 1 === 0 ? 0 : 2);
        return input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + '%';
      }else{
        return '-'
      }
    };
  }
]);

clickxApp.filter('adReportFilter', [
  '$filter',
  function($filter) {
    return function(input) {
      if (input != null) {
        input = parseFloat(input);
        input = input.toFixed(input % 1 === 0 ? 0 : 2);
        return input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      }else{
        return '-'
      }
    };
  }
]);

clickxApp.filter('snakeCase', [
  '$filter',
  function($filter) {
    return function(input) {
      return input.replace(' ', '_').toLowerCase();
    };
  }
]);

function pad2(number) {
  return (number < 10 ? '0' : '') + number;
}

clickxApp.filter('toDuration', function() {
  return function(input) {
    var hours = pad2(parseInt(input / 3600, 10));
    var minutes = pad2(parseInt((input % 3600) / 60));
    var seconds = pad2(parseInt(input % 60));
    return hours + ':' + minutes + ':' + seconds;
  };
});

clickxApp.filter('numberWithSign', function() {
  return function(input) {
    return input ? (input > 0 ? '+' : '') + input : '--';
  };
});
clickxApp.filter('packagePrice', function() {
  return function(plan) {
    if(plan){
      amount = parseFloat(plan['amount']);
      amount = amount.toFixed(amount % 1 === 0 ? 0 : 2);
      amount = '$' + amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
      if(plan['interval'] == 'month'){
        amount = amount + '/mo';
      }
      return amount
    }
  };
});
