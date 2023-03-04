clickxApp.directive('clickxFormCreate', [
  function() {
    var ClickxFormObject = {};
    ClickxFormObject.link = function(scope, element, attr) {
      'use strict';
      if (scope.form) {
        var formId =
          scope.id || scope.form.id || 'rp-custom-form-' + scope.index;
        var formElement = $('<form/>', {
          id: formId
        });
        if (scope.actionUrl) {
          formElement.attr('action', scope.actionUrl);
        }
        if (scope.methodType) {
          formElement.attr('method', scope.methodType);
        }
        if (scope.validationRequired) {
          formElement.data('validation', scope.validateRequired);
        }

        scope.form.select_fields = _.map(scope.form.select_fields, function(
          value
        ) {
          value['type'] = 'select';
          return value;
        });

        var inputsAll = _.union(scope.form.select_fields, scope.form.inputs);

        _.each(inputsAll, function(value, index) {
          var formInputField;
          var formLabel;
          var ordinaryInputs = [
            'text',
            'email',
            'number',
            'checkbox',
            'radio',
            'password',
            'hidden',
            'search'
          ];
          if (value.placeholder || value.name) {
            formLabel = $('<label/>', {
              class: 'control-label'
            }).html(
              (value.placeholder || value.name || value['aria-label']) +
                "<span class='field-name'>(Input field name:" +
                (value.name || 'Not available') +
                ')</span>'
            );
          }
          if (_.indexOf(ordinaryInputs, value.type) > -1) {
            if (
              typeof value.placeholder == 'undefined' &&
              typeof value['aria-label'] != 'undefined'
            ) {
              value['placeholder'] = value['aria-label'];
            }
            formInputField = $(
              '<input/>',
              _.pick(value, 'id', 'class', 'name', 'placeholder', 'type')
            );
          } else if (value.type == 'select') {
            formInputField = $('<select/>', _.omit(value, 'options'));
            var options = _.map(value.options, function(value) {
              return '<option value="' + value + '">' + value + '</option>';
            });
            formInputField.html(options);
            //console.log(formInputField)
          } else if (value.type == 'textarea') {
            formInputField = $('<textarea/>', value);
          } else if (value.type == 'submit') {
            formInputField = $('<input/>', value);
          } else if (value.type == 'button') {
            formInputField = $('<button/>', value);
            if (value.value) formInputField.val(value.value);
          } else if (typeof value.type == 'undefined') {
            if (
              typeof value.placeholder == 'undefined' &&
              typeof value['aria-label'] != 'undefined'
            ) {
              value['placeholder'] = value['aria-label'];
            }
            formInputField = $(
              '<input/>',
              _.pick(value, 'id', 'class', 'name', 'placeholder', 'type')
            );
          }
          if (
            _.indexOf(['password', 'text', 'email', 'search'], value.type) > -1
          ) {
            try {
              formInputField.addClass('form-control');
            } catch (e) {
              console.log(e);
            }
          }

          var formGroup = $('<div/>', {
            class: 'form-group'
          });
          if (formLabel) {
            formGroup.append(formLabel);
          }

          formGroup.append(formInputField);
          if (
            typeof scope.removeExtra == 'undefined' ||
            scope.removeExtra == false
          ) {
            //console.log(value)
            if (formInputField) {
              var formSelectedCheckBox = $('<input/>', {
                type: 'checkbox',
                class: 'select-checkbox',
                value: 1
              });
              if (value['data-selected'] || value['selected']) {
                formSelectedCheckBox.prop('checked', true);
              } else {
                formSelectedCheckBox.prop('checked', false);
              }
              formSelectedCheckBox.attr('data-value', JSON.stringify(value));
              formGroup.append(formSelectedCheckBox);
            }
          }
          formElement.append(formGroup);
        });

        if (formElement) {
          if (
            typeof scope.removeExtra == 'undefined' ||
            scope.removeExtra == false
          ) {
            var formSelectFormLabel =
              "<label><input type='checkbox' class='form-select' ";
            if (scope.formId) {
              formSelectFormLabel += "checked='checked'";
            }
            formSelectFormLabel += "value='1'><span></span></label>";
            $(element).append(formSelectFormLabel);
          }
        }
        $(element).append(formElement);
      }

      /**
       * Select form elements
       */
      $(element)
        .find('input[type="checkbox"].select-checkbox')
        .on('click', function() {
          var currentSelection = $(this).data('value');
          // Check for normal inputs
          var ifExists = _.findWhere(scope.form.inputs, currentSelection);
          // Check for select inputs
          if (typeof ifExists == 'undefined') {
            ifExists = _.find(scope.form.select_fields, function(value) {
              if (
                value.name &&
                currentSelection.name &&
                currentSelection.name == value.name
              )
                return true;
              if (
                value.placeholder &&
                currentSelection.placeholder &&
                currentSelection.placeholder == value.placeholder
              )
                return true;
            });
          }
          if (typeof ifExists != 'undefined') {
            ifExists['selected'] = true;
            if (!$(this).prop('checked')) {
              delete ifExists['selected'];
            }
          }
        });

      /**
       * Select form
       */
      $(element)
        .find('.form-select')
        .click(function() {
          var _this = this;
          scope.$apply(function() {
            scope.form['selected'] = true;
            if (!$(_this).prop('checked')) delete scope.form['selected'];
          });
        });
    };
    ClickxFormObject.scope = {
      form: '=form',
      index: '=index',
      formId: '=formId',
      removeExtra: '=removeExtra'
    };
    ClickxFormObject.restrict = 'EA';
    ClickxFormObject.replace = true;
    ClickxFormObject.template = '<div class="clickx-form-wrapper"></div>';
    return ClickxFormObject;
  }
]);

/**
 * ADVANCED PANEL DIRECTIVE
 */

clickxApp.directive('panelAdvanced', function() {
  'use strict';
  return {
    restrict: 'C',
    replace: true,
    transclude: true,
    scope: {
      form: '=form'
    },
    link: function(scope, element, attr, ctrl, transcludeFn) {
      scope.toggle = false;

      transcludeFn(scope.$parent.$new(), function(content) {
        element.append(content);
      });

      var panelBody = $(element).find('.panel-body');
      panelBody.addClass('timing');
      $(element)
        .find('.panel-heading')
        .click(function() {
          var spanElement = $(this)
            .find('.toggle')
            .children('span');
          if (!scope.toggle) {
            spanElement
              .removeClass('fa-chevron-down')
              .addClass('fa-chevron-up');
            panelBody.addClass('collapsing');
            setTimeout(function() {
              panelBody.removeClass('collapsing').addClass('in');
            }, 300);
          } else {
            spanElement
              .addClass('fa-chevron-down')
              .removeClass('fa-chevron-up');
            setTimeout(function() {
              panelBody.removeClass('collapsing').removeClass('in');
            }, 300);
          }
          scope.toggle = !scope.toggle;
        });
    }
  };
});
