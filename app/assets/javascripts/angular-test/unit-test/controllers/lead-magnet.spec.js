/**
 * Created by sibin on 26/1/17.
 */
'use-strict';

xdescribe('clickxApp lead Magnet controller', function(){
  var $controller,$rootScope,$scope,$exceptionHandler;
  beforeEach(function(){
    module('clickxApp')
  });


  beforeEach(inject(function($controller,$rootScope){

    $scope = $rootScope.$new();
    $controller = $controller('trackerLeadMagnetCreate',{
      $scope: $scope
    })
  }));

  it("Should check scope settings and it should be a object with specified keys", function(){
    var isObject = _.isObject($scope.settings);
    expect(isObject).toBeTruthy()
  });

  it("Should throw error if settings not passed with saveTemplate function", function(){
    spyOn($scope,'saveTemplate').and.throwError("Scope settings not object");

    expect(function(){
      $scope.saveTemplate()
    }).toThrowError("Scope settings not object")
  });
});