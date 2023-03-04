xdescribe("Lead Magnet directives", function(){
  var $compile,$scope;
  beforeEach(function(){
    module('clickxApp')
    inject(function(_$compile_,_$rootScope_){
      $compile = _$compile_;
      $scope   = _$rootScope_.$new();
    });
  });

  describe("Lead magnet plain text link", function(){
    var element,compiledElement;
    beforeEach(function(){
      $scope.settings = {};
      element = angular.element("<lead-magnet-plain-text-link settings='settings'></lead-magnet-plain-text-link>");
      compiledElement = $compile(element)($scope);
      $scope.$digest();
    });

    it("should hidden if title value is not set", function(){
      var visibility = compiledElement.is(":visible");
      expect(visibility).not.toBeTruthy();
    });
    it("should visible if scope.settings.link.text is set", function(){
      $scope.settings = {
        link:{
          text:"Sample text"
        }
      }
      $scope.$digest();
      var visibility = compiledElement.is(":visible");
      expect(visibility).not.toBeTruthy();
    });
    it("should print text for given scope.settings.link.text", function(){
      $scope.settings = {
        link:{
          text:'Sample text'
        }
      }
      $scope.$digest();
      var currentText = compiledElement.text();
      expect(currentText).toEqual("Sample text")
    });

    // Styles

    it("should not have style attribute if scope.settings.link.style not set", function(){
      $scope.settings = {};
      $scope.$digest();
      var elementToString = compiledElement[0].outerHTML.toString();
      var styleMatches = elementToString.match(/style/g);
      expect(styleMatches.length).toEqual(2)
    });

    it("should  have style attribute if scope.settings.link.style is set", function(){
      $scope.settings = {
        link:{
          style:{
            fontSize:14,
            color:'#333'
          }
        }
      };
      $scope.$digest();
      var elementToString = compiledElement[0].outerHTML.toString();
      var styleMatches = elementToString.match(/style/g);
      expect(styleMatches.length).toEqual(3)
    });

  });
})
