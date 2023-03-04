/**
 * Created by sibin on 26/1/17.
 */
describe('Test helpers filters', function(){
  var $filter,$sce;
  beforeEach(function(){
    module('clickxApp');
    inject(function(_$filter_,_$sce_){
      $filter = _$filter_;
      $sce    = _$sce_;
    });
  });

  xit("should return start and end week date separated by '-'", function(){
    var defaultDate = moment("2017-01-26","YYYY-MM-DD").format("X");
    var startEndWeek = $filter('startAndEndDays')(defaultDate)
    expect(startEndWeek).toEqual("January 22nd Sunday-January 28th Saturday")
  });

  xit("should return 'Unknown Days if input is not in correct format (timestamp, X)", function(){
    var defaultDate = "XXXX";
    var startEndWeek = $filter('startAndEndDays')(defaultDate);
    expect(startEndWeek).toEqual("Unknown Days");
  });

  xit("should return a usa date format with prefix and suffix if exist", function(){
    var defaultDate = moment("2017-01-26","YYYY-MM-DD").format();
    var result = $filter('usaDateFormat')(defaultDate,"(",")");
    expect(result.toString()).toEqual('<span>(01-26-2017)</span>')
  });

  xit("should return editable element if date is invalid", function(){
    var defaultDate = "XXXX";
    var result = $filter('usaDateFormat')(defaultDate,"(",")");
    expect(result.toString()).toEqual("<span class='editable editable-click editable-empty'>Add Date of Birth</span>")

  });

  xit("should convert a string to capitalize", function(){
    var defaultString = "hello world";
    var result = $filter('capitalize')(defaultString);
    expect(result).toEqual("Hello world")
  });

  xit("should return a fromNow moment value", function(){
    var defaultDate = moment("2017-01-26:00:00:00","YYYY-MM-DD:HH:mm:ss").format();
    var result = $filter('fromNowMoment')(defaultDate);
    expect(result).toMatch(/ago$/)
  });

  // hello world => Hello world
  xit('should return humanize type of input', function() {
    var input    = 'hello world';
    var expected = 'Hello world';
    var test     = $filter('humanize')(input);
    expect(test).toEqual(expected);
  });

  // google.com => http://google.com
  xit('should return full web address', function() {
    var input    = 'google.com';
    var expected = 'http://google.com';
    var test     = $filter('get_full_website')(input);
    expect(test).toEqual(expected);
  });

  // check html escape
  it('should perform html escape action', function() {
    var inputText   = '<b>Hello World</b>';
    var expected    = '<b>Hello World</b>';
    var text        = $filter('commentHtmlSafe')(inputText);
    expect(text.$$unwrapTrustedValue()).toEqual(expected);
  });
});


/**
 * @description Check `tel` angular custom filter
 * @author Jerry Brown
 */

xdescribe('Check `tel` custom filter', function() {
  var $filter;
  beforeEach(function(){
    module('clickxApp');
    inject(function(_$filter_){
      $filter = _$filter_;
    });
  });

  it('should return same phone number if it length 10', function() {
    var input    = 9876543210;
    var expected = '(987) 654-3210';

    var test     = $filter('tel')(input);
    expect(test).toEqual(expected);
  });

  it('should return same phone number if it length 11', function() {
    var input    = 98765432109;
    var expected = '9 (876) 543-2109';

    var test     = $filter('tel')(input);
    expect(test).toEqual(expected);
  });

  it('should return same phone number if it length 12', function() {
    var input    = 987654321098;
    var expected = '987 (65) 432-1098';

    var test     = $filter('tel')(input);
    expect(test).toEqual(expected);
  });

  it('should return same phone number is less than 10 number', function() {
    var input    = 987654321;
    var expected = 987654321;
    var test     = $filter('tel')(input);
    expect(test).toEqual(expected);
  });
});

/**
 * @description Check date, time and other related features
 * @see moment js, jasmine
 * @author Jerry Brown
 */
xdescribe('Check date, time and moment values', function() {
  var $filter;
  beforeEach(function(){
    module('clickxApp');
    inject(function(_$filter_){
      $filter = _$filter_;
    });
  });
});