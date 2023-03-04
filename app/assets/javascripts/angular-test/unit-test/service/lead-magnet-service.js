/**
 * Created by sibin on 26/1/17.
 */

xdescribe("Lead Magnet service", function(){
  var leadMagnetService,$httpBackend,$http;
  beforeEach(function(){
    module('clickxApp');
    inject(function(LeadMagnet,_$httpBackend_,_$http_){
      leadMagnetService = LeadMagnet;
      $httpBackend = _$httpBackend_;
      $http = _$http_;

    });
    $httpBackend.whenGET(/^\/lead-magnet\/\d{1,}$/).respond(function(){
      return [200,{data:{}}]
    });
    $httpBackend.whenGET("/lead-magnet").respond(function(){
      return [200,[{},{}]]
    })
  });

  it("should define LeadMagnet service", function(){
    expect(leadMagnetService).toBeDefined()
  });

  it("should send list of array with objects(collection) on index url",function(){
    var datas;
    leadMagnetService.query(function(result){
      datas = result;
    });
    $httpBackend.flush();
    expect(Array.isArray(datas)).toBe(true);
    expect(_.isObject(datas[0])).toBe(true);

  });
  it("should send a GET request as object", function(){
    //$httpBackend.expectGET('/lead-magnet/10');
    var data;
    leadMagnetService.get({id:100}, function(response){
      data = response;
    });

    $httpBackend.flush();
    expect(_.isObject(data)).toBe(true)
  });


  afterEach(function(){
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  })
});