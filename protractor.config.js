/**
 * Created by sibin on 26/1/17.
 */

exports.config ={
  framework:'jasmine',
  specs:[
    './app/assets/javascripts/angular-test/e2e-test/**/*.js'
  ],
  seleniumServerStartTimeout: 60000,
  jasmineNodeOpts:{
    defaultTimeoutInterval: 60000
  }
};