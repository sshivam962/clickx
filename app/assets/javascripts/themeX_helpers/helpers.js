/* Breadcrumb for Analytic Pages */
clickxApp.directive('clickxBreadcrumb', [
  '$interpolate', '$routeParams',
  function ($interpolate, $routeParams) {
    "use strict";
    return {
      restrict: 'AEC',
      replace: true,
      scope: {
        links: '=',
        enabled: '='
      },
      template: '<ol class="breadcrumb clx-breadcrumb"></ol>',
      link: function (scope, element, attr, ctrl, transclideFn) {
        var scopeLinks = [];
        var breadCrumbEle = $(element);
        scope.$watchGroup(['links','enabled'], function(newGroup, oldGroup){
          var linkValues = {
            b_id: $routeParams.b_id || $routeParams.business_id || '',
            business_id: $routeParams.b_id || $routeParams.business_id || '',
            c_id: $routeParams.c_id || $routeParams.t_id || '',
            t_id: $routeParams.t_id || $routeParams.c_id || '',
            id: $routeParams.id || '',
            l_id: $routeParams.l_id || '',
            doc_id: $routeParams.doc_id || '',
            keyword: $routeParams.keyword || '',
            location_id: $routeParams.location_id || '',
            dir: $routeParams.dir || '',
            f_id: $routeParams.f_id || ''
          };
          var links = newGroup[0];
          var enabled = newGroup[1];
          if(enabled) {
            scopeLinks = $('<li/>').html('<a href=\'/b/dashboard\'>Home</a>');
            if (angular.isDefined(links) && _.isArray(links) && links.length > 0) {
              scopeLinks = _.map(links, function (value, index, list) {
                if(value.name && value.link){
                  value.link = $interpolate(value.link)(linkValues);
                  if(list.length === (index + 1)){
                    return $interpolate('<li><span>{{name}}</span></li>')(value);
                  }
                  return $interpolate('<li><a href=\'{{link}}\'>{{name}}</a></li>')(value);
                }else{
                  return null;
                }
              });
              scopeLinks = _.compact(scopeLinks);
            }
            breadCrumbEle.html(scopeLinks).parent().removeClass('hidden');
          }else{
            breadCrumbEle.parent().addClass('hidden');
          }
        });
      }
    };
  }
]).controller('BreadcrumbController',[
  '$scope','$rootScope',
  function($scope, $rootScope){
    $rootScope.$on('$routeChangeSuccess', function(event, newUrl, oldUrl){
      if(newUrl.loadedTemplateUrl == "themeX/grader/index.html"){
        $rootScope.breadcrumbEnabled = false;
        return false
      }
      if(angular.isDefined(newUrl)){
        var breadcrumbs = newUrl.breadcrumb;
        if(angular.isDefined(breadcrumbs)){
          if(angular.isUndefined(breadcrumbs.enabled)){
            $rootScope.breadcrumbEnabled = true;
          }else{
            $rootScope.breadcrumbEnabled = breadcrumbs.enabled;
          }
          $rootScope.breadcrumbLinks = breadcrumbs.links;
        }else{
          $rootScope.breadcrumbEnabled = true;
        }
      }
    });
  }
]);

clickxApp.directive('websiteAnalyticLinkBox',[
  '$routeParams','clickxHelperService','$interpolate','LiveTrackingWebsite',
  function($routeParams,clickxHelperService,$interpolate,LiveTrackingWebsite){
    "use strict";
    return {
      restrict:'C',
      replace: true,
      templateUrl:"themeX/website/tracking_analytics/analytic_sidebar.html",
      link: function(scope, element, attr){
        scope.defaultLinks = clickxHelperService.getLinkList();
        scope.trackerDetails = {};
        scope.b_id = $routeParams.business_id || $routeParams.b_id;
        scope.t_id = $routeParams.t_id || $routeParams.c_id;
        LiveTrackingWebsite.get({
          business_id: scope.b_id,
          id: scope.t_id
        }, function(result){
          scope.trackerDetails = result;
        }, function(error){
          toastr.error(error.statusText)
        })
      }
    }
  }
]);

clickxApp.directive('clickxFormCreateNew',[function(){
  var ClickxFormObject = {};
  ClickxFormObject.link = function(scope, element, attr){
    "use strict";
    if(scope.form.form){
      var formNumber = (scope.index + 1)
      var formId = scope.form.form.id || scope.form.form.id || 'rp-custom-form-' + scope.index;
      var formElement = $('<form/>',{
        id: formId
      });
      if (scope.actionUrl) {
        formElement.attr('action', scope.actionUrl)
      }
      if (scope.methodType) {
        formElement.attr('method', scope.methodType)
      }
      if (scope.validationRequired) {
        formElement.data('validation', scope.validateRequired)
      }

      scope.form.form.select_fields = _.map(scope.form.form.select_fields, function(value){
        value['type'] = 'select';
        return value;
      });
      var inputsAll = _.union(scope.form.form.select_fields, scope.form.form.inputs);

      _.each(inputsAll, function (value, index) {
        var formInputField;
        var formLabel;

        var ordinaryInputs = ['text','email','number','checkbox','radio','password','hidden','search','url'];
        if(value.placeholder || value.name){
          formLabel = $("<label/>",{
            class:'control-label'
          }).html((value.placeholder || value.name || value['aria-label']) +"<small class='field-name'>(Input field name:"+(value.name || "Not available")+")</small>")
        }
        if (_.indexOf(ordinaryInputs, value.type) > -1) {
          if(typeof value.placeholder == "undefined" && typeof value['aria-label']!="undefined"){
            value['placeholder'] = value['aria-label'];
          }
          formInputField = $('<input/>', _.pick(value,'id','class','name','placeholder','type'))
        }else if(value.type == 'select'){
          formInputField = $('<select/>', _.omit(value,'options'));
          var options = _.map(value.options, function(value){
            return '<option value="'+value+'">'+value+'</option>';
          });
          if(!formInputField.hasClass('form-control')){
            formInputField.addClass('form-control')
          }
          formInputField.html(options)

        }else if(value.type == 'textarea'){
          formInputField = $('<textarea/>',value)
        }else if(value.type == 'submit'){
          formInputField = $('<input/>',value)
          formInputField.addClass('btn btn-raised btn-primary')
        }else if((_.indexOf(['button','submit','reset'],value.type) > -1)
          && typeof value.localName != "undefined"
          && value.localName=="button") {
          formInputField = $('<button/>', value);
          formInputField.addClass('btn btn-raised btn-primary');
          if (value.value)
            formInputField.html(value.value)
        }else if(typeof value.type == "undefined"){
          if(typeof value.placeholder == "undefined" && typeof value['aria-label']!="undefined"){
            value['placeholder'] = value['aria-label'];
          }
          formInputField = $('<input/>',_.pick(value,'id','class','name','placeholder','type'))
        }

        if(_.indexOf(['password','text','email','search','textarea','search','url',
            'date','month','password','time','week','tel','phone','number'],value.type)>-1){
          try{
            formInputField.addClass('form-control')
          }catch(e){
            console.log(e)
          }
        }
        if( typeof value.type=="undefined" || value.type == null){
          formInputField.addClass('form-control')
        }
        var formGroup = $('<div/>',{
          class:'form-group'
        });
        if(formLabel){
          formGroup.append(formLabel)
        }

        var formInputGroup = $('<div/>',{class:'input-group'});
        formInputGroup.append(formInputField);
        if(typeof scope.removeExtra=="undefined" || scope.removeExtra==false){
          //console.log(value)
          /**
           * @TODO find a simple solution for all condition
           */
          if(["submit","reset","button","hidden"].indexOf(value.type)==-1){// show if field is not hidden
              if(formInputField){
                  var formSelectInputAddon = $('<div/>',{
                      class:'input-group-addon checkbox pr-n'
                  });
                  var formSelectInputLabel = $('<label/>');
                  var formSelectedCheckBox = $('<input/>',{
                      type:"checkbox",
                      class:'select-checkbox',
                      value:1
                  });


                  if(value['data-selected'] || value['selected']){
                      formSelectedCheckBox.prop('checked',true)
                  }else{
                      formSelectedCheckBox.prop('checked',false)
                  }
                  formSelectedCheckBox.attr('data-value',JSON.stringify(value));


                  var formSelectedSpan = $('<span/>',{
                      class:'checkbox-material'
                  }).html("<span class='check'></span>");

                  formSelectInputLabel.append(formSelectedCheckBox);
                  formSelectInputLabel.append(formSelectedSpan);

                  formSelectInputAddon.append(formSelectInputLabel);
                  formInputGroup.append(formSelectInputAddon);
              }
          }
        }
        formGroup.append(formInputGroup);
        formElement.append(formGroup)
      });
      var formId = scope.form.form.id;
      var formNameField = $('<div class="form-group"><label class="control-label">'+
      'Your Form Name</label></div>')
      var formNameInput = $('<input class="form-control" id = "FormId'+formId+'"'+
      'placeholder="Form Name" type="text">')

      if(scope.form.name){
        formNameInput.val(scope.form.name);
      } else {
        formNameInput.val("Form "+formNumber);
      }
      formNameField.append(formNameInput)
      formElement.prepend(formNameField);




      if(formElement){
        if(typeof scope.removeExtra=="undefined" || scope.removeExtra==false){
          var formSelectFormLabel = "<div class='togglebutton toggle-warning'><label><input type='checkbox' class='form-select' ";
          if(scope.formId){
            formSelectFormLabel += "checked='checked'";
          }
          formSelectFormLabel +="value='1'><span class='toggle'></span></label></div>";
            var panelControl = $('<div/>',{
                class:'panel-controls'
            }).append(formSelectFormLabel);
          //$(element).append(formSelectFormLabel)
        }
      }
      var panelBox = $('<div/>',{
          class:'panel panel-default'
      });
      var panelHeader = $('<div/>',{
          class:'panel-heading'
      });
      if(scope.form.name){
        panelHeader.html("<h2 id='formHeading"+scope.form.id+"'>"+scope.form.name+"</h2>");
      } else {
        panelHeader.html("<h2 id='formHeading"+scope.form.id+"'> Form "+formNumber+"</h2>");
      }
      var panelBody = $('<div/>',{
          class:'panel-body'
      }).append(formElement);

      if(panelControl){
          panelBox.append(panelControl);
      }
      panelBox.append(panelHeader);
      panelBox.append(panelBody);
      $(element).append(panelBox);
    }
    $("#formHeading"+scope.form.id).css("text-transform", "none");

    $("#FormId"+scope.form.id).keyup(function(){
      $("#formHeading"+scope.form.id).text($(this).val());
    });
    /**
     * Select form elements
     */
    $(element).find('input[type="checkbox"].select-checkbox').on('click', function(){
      var currentSelection = $(this).data('value');
      // Check for normal inputs
      var ifExists = _.findWhere(scope.form.form.inputs,currentSelection);
      // Check for select inputs
      if (typeof ifExists == "undefined") {
        ifExists = _.find(scope.form.form.select_fields, function (value) {
          if (value.name && currentSelection.name && currentSelection.name == value.name) return true
          if (value.placeholder && currentSelection.placeholder && currentSelection.placeholder == value.placeholder) return true
        })
      }
      if (typeof ifExists != "undefined") {
        ifExists['selected'] = true;
        if (!($(this).prop('checked'))) {
          delete ifExists['selected']
        }
      }

    });

    /**
     * Select form
     */
    $(element).find('.form-select').click(function(){
      var _this = this;
      scope.$apply(function(){
        scope.form.form['selected'] = true;
        if(!($(_this).prop('checked'))) delete scope.form.form['selected'];
      })


    })

  };
  ClickxFormObject.scope = {
    form:'=form',
    index:'=index',
    formId:'=formId',
    removeExtra:'=removeExtra'
  };
  ClickxFormObject.restrict = 'EA';
  ClickxFormObject.replace  = true;
  ClickxFormObject.template = '<div class="clickx-form-wrapper"></div>';
  return ClickxFormObject;
}]);
