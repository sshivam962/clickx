/**
 * Created by sibin on 26/1/17.
 */

xdescribe("Protractor Test Demo", function(){
  beforeEach(function(){
    browser.ignoreSynchronization = true;
  });
  it("it should redirect to user login or business page", function(done){
    browser.get('http://localhost:3000/users/sign_in');
    expect(browser.getTitle()).toEqual("Login");
    done();
  });
  it("it should fill login form", function(done){
    browser.get('http://localhost:3000/users/sign_in');
    element(by.id('user_login')).sendKeys("andy@oneims.com");
    element(by.id('user_password')).sendKeys('123qwerty');
    element(by.css('.btn-warning')).click().then(function(){
      browser.waitForAngular()
      expect(browser.getTitle()).toEqual("Business list");
      done();
    });
  });
  it("it should click create client button", function(done){
    browser.waitForAngular();
    browser.sleep(1000);
    element(by.className('new_campaign_btn')).click().then(function(){
      done();
    });
  });

  it("it should navigate to create client page", function(done){
    browser.get("http://localhost:3000/#/businesses/new");
    expect(element(by.css('.header h1')).getText()).toEqual("Add New Client");
    done();
    browser.close();
    browser.restart();
  });
});

/**
 * @description Get to Business listing page, then focus to label select box, type
 * `Maria` then wait and check Maria in current listing
 *
 * 1: Log using username and password and wait for angular js
 * 2: Focus/Click on label search box
 * 3. Search for `Maria`, and check result
 */

xdescribe('Client labels selection', function() {
  beforeEach(function() {
    browser.ignoreSynchronization = true;
  });

  it('It should log using existing Username and Password', function(done) {
    browser.get('http://localhost:3000/users/sign_in');
    element(by.id('user_login')).sendKeys('andy@oneims.com');
    element(by.id('user_password')).sendKeys('123qwerty');
    element(by.css('.btn-warning')).click().then(function(){
      browser.waitForAngular();
      done();
    });
  });

  it('It should click on label search box and Type `Maria`', function(done) {
    element(by.model('$select.search')).sendKeys('Maria');
    done();
  });

  it('It should select Maria from list', function(done) {
    element(by.repeater('label in $select.items').row(1)).click().then(function() {
      done();
    });

  });

  it('It should see Maria in business list', function(done) {
    browser.sleep(1000);
    var parentElement   = element.all(by.repeater('biz in businesses'));
    browser.sleep(1000);
    expect(parentElement.first()
      .all(by.repeater('lab in biz.labels_list')).getText()).toContain('Maria');
    done();
    browser.restart();
  });
});
