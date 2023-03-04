/**
 * @description Get Business client Dashboard
 *
 * Step:
 * ----
 * 1. Log using Username and Password
 * 2. Get to business list page
 * 3. Search for clickx client
 * 4. Select clickx and logged using first user from sidebar
 * 5. Get into client dashboard
 **/

xdescribe('Get into client dashboard', function() {
  beforeEach(function() {
    browser.ignoreSynchronization=true;// login page is not angular
  });

  it('It should log and get into Business page', function(done) {
    browser.get('http://localhost:3000/users/sign_in');
    element(by.id('user_login')).sendKeys('andy@oneims.com');
    element(by.id('user_password')).sendKeys('123qwerty');
    element(by.css('.btn-warning')).click().then(function(){
      browser.waitForAngular();
      expect(browser.getTitle()).toEqual('Business list');
      done();
    });
  });

  it('It should search for Clickx client', function(done) {
    element(by.model('search_biz.name')).sendKeys('clickx');
    browser.sleep(1000);
    done();
  });

  it('It should click on Clickx client', function(done) {
    element(by.repeater('biz in businesses').row(0)).element(by.css('.rp-business-list-item a'))
      .click().then(function(){
        browser.sleep(2000);
        done();
      });
  });

  it('It should select first user and login to Dashboard', function(done) {
    element(by.repeater('user in biz.users').row(0))
      .element(by.cssContainingText('.btn','Log In')).click().then(function() {
        browser.sleep(2000);
        done();
      });
  });

  it('It should see Client Dashboard', function(done) {
    browser.waitForAngular();
    expect(browser.getTitle()).toEqual('Dashboard');
    done();
    browser.close();
    browser.restart();
  });

});
