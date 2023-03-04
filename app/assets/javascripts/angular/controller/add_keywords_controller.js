clickxApp.controller('AddKeyword', [
  '$scope',
  '$rootScope',
  'Business',
  'business',
  '$timeout',
  '$mdDialog',
  'data',
  function($scope, $rootScope, Business, business, $timeout, $mdDialog, data) {
    var colors = ['#808080', '#000000', '#FF0000', '#800000', '#FFFF00',
      '#00FF00', '#008000', '#00FFFF', '#008080', '#0000FF', '#FF00FF', '#800080'];
    $scope.keywords = {
      add_keyword: [],
      add_keyword_text: '',
      keyword_array: [],
      exisiting_keywords: []
    };

    $scope.business = business;
    $scope.keywords.locale = $scope.business.locale;
    $scope.keywords.city = $scope.business.target_city;

    $scope.keyword_tags = [];

    $scope.allCountryList = function() {
      Business.country_locale(function(response) {
        $scope.countryList = response.data;
      });
    };

    $scope.allCountryList();

    $scope.setLocation = function() {
      var country = $scope.getCountryFromLocale($scope.keywords.locale);
      var country_code = $scope.keywords.locale
        ? $scope.keywords.locale.split('-')[1].trim() || 'us'
        : null;
      $scope.options = {
        types: ['(regions)'],
        componentRestrictions: {
          country: country_code
        }
      };
      $scope.keywords.city = country;
    };

    $scope.getCountryFromLocale = function(locale) {
      country = 'United States - English';
      $.each($scope.countryList, function(i, locale_info) {
        if (locale == locale_info.locale) {
          country = locale_info.country;
        }
      });
      return country.split('-')[0].trim() || 'United States';
    };

    if(!$scope.keywords.city){
      $scope.setLocation()
    }

    var checkKeywordExist = function() {
      var flag = true;
      var text = $scope.keywords.add_keyword_text;
      if (angular.isDefined(typeof text) && text !== null) {
        if (!_.isEmpty(text)) {
          try {
            $scope.adding_kw_length = text
              .split(/\r\n|\r|\n/)
              .filter(Boolean).length;
            var items = ($scope.keywords.add_keyword =
              text.length > 0 ? text.split(/\n/) : []);
            var exisitngKeywords = $scope.keywords.exisiting_keywords;
            items.forEach(function(item, index) {
              if (_.indexOf(exisitngKeywords, item.toLowerCase()) != -1) {
                toastr.warning(item + ' already exists');
                $scope.keywords.add_keyword = _.without(
                  $scope.keywords.add_keyword,
                  item
                );
                flag = false;
                return;
              }
            });
            $scope.keywords.add_keyword_text = $scope.keywords.add_keyword.join(
              '\n'
            );
            if ($scope.kw_remaining_temp > $scope.adding_kw_length) {
              $scope.keywords.remaining_count =
                $scope.kw_remaining_temp - $scope.adding_kw_length;
            } else {
              $scope.keywords.remaining_count = 0;
            }
            if ($scope.keywords.add_keyword_text.length === 0) {
              $scope.addKeyword.$setPristine();
              $scope.addKeyword.keywords.$setPristine();
              $scope.addKeyword.keywords.$setValidity(false);
              $scope.addKeyword.keywords.$render();
            }
          } catch (e) {}
        } else {
          /// same as null case
          $scope.keywords.add_keyword = [];
          $scope.addKeyword.keywords.$viewValue = '';
          $scope.addKeyword.keywords.$render();
          $scope.keywords.remaining_count = $scope.kw_remaining_temp;
          toastr.warning('Please type atleast a Word');
        }
      }
      return flag;
    };

    if (data.possibilities.length) {
      $scope.keywords.add_keyword_text = data.possibilities.join('\n');
      $timeout(function() {
        if (checkKeywordExist()) {
          $scope.addKeyword.keywords.$setDirty();
          $scope.addKeyword.keywords.$setValidity(false);
        }
      });
    }
    $scope.business_id = current_business;
    $scope.kq_q_full = false;

    $scope.go_back = function() {
      $mdDialog.cancel('cancel');
    };

    $scope.transformChip = function(chip) {
      if (angular.isObject(chip)) {
        return chip;
      }

      return { name: chip, color: colors[Math.floor(Math.random() * 12)] };
    };

    $scope.selectTag = function(tag) {
      $scope.keyword_tags.push(tag);
      $scope.refreshAvailableTags();
    };

    $scope.getTags = function() {
      Business.all_keyword_tags(
        {
          id: $scope.business_id
        },
        function(result) {
          $scope.all_keyword_tags = result.businesses_keyword_tags;
          $scope.available_tags = $scope.all_keyword_tags.slice();
        },
        function(error) {
          toastr.error(error.statusText);
        }
      );
    };

    $scope.refreshAvailableTags = function() {
      $scope.available_tags = _.difference($scope.all_keyword_tags, $scope.keyword_tags);
    };


    $scope.getTags();

    $rootScope.keywordResult.$promise.then(function(result) {
      $scope.keywords.keywords_limit = result.keyword_limit;
      $scope.keywords.exisiting_keywords = _.map(result.data, function(
        keyword,
        index
      ) {
        return keyword.name;
      });
      $scope.keywords.remaining_count = $scope.kw_remaining_temp =
        result.keyword_limit - result.total_size;
    });

    $scope.getKeywords = function(event) {
      if (event === null) {
        checkKeywordExist();
        return;
      }
      if (event && event.keyCode == 13) {
        checkKeywordExist();
      }
    };

    $scope.saveKeyword = function(e) {
      if (!$scope.keyword_tags.length && $scope.searchText)
        $scope.keyword_tags[0] = { name: $scope.searchText, color: colors[Math.floor(Math.random() * 12)] };
        ensureKeywordList()
      // if (checkKeywordExist()) {
        if ($scope.kw_remaining_temp < $scope.adding_kw_length) {
          toastr.warning(
            'Keyword limit reached. These keywords will be added to Wishlist'
          );
        }
        $('#add_keyword_form')
          .find('.btn-warning')
          .attr('disabled', 'disabled');
        var params = {
          keyword: $scope.keywords.add_keyword,
          tags: $scope.keyword_tags,
          city: $scope.keywords.city,
          locale: $scope.keywords.locale
        };
        $scope.addKeywordToBank(params);
        return false;
      // }
    };

    var ensureKeywordList = function() {
      var text = $scope.keywords.add_keyword_text;
      if (angular.isDefined(typeof text) && text !== null) {
        if (!_.isEmpty(text)) {
          try {
            $scope.adding_kw_length = text
              .split(/\r\n|\r|\n/)
              .filter(Boolean).length;
            var items = ($scope.keywords.add_keyword =
              text.length > 0 ? text.split(/\n/) : []);
            $scope.keywords.add_keyword_text = $scope.keywords.add_keyword.join(
              '\n'
            );
            if ($scope.kw_remaining_temp > $scope.adding_kw_length) {
              $scope.keywords.remaining_count =
                $scope.kw_remaining_temp - $scope.adding_kw_length;
            } else {
              $scope.keywords.remaining_count = 0;
            }
            if ($scope.keywords.add_keyword_text.length === 0) {
              $scope.addKeyword.$setPristine();
              $scope.addKeyword.keywords.$setPristine();
              $scope.addKeyword.keywords.$setValidity(false);
              $scope.addKeyword.keywords.$render();
            }
          } catch (e) {}
        } else {
          /// same as null case
          $scope.keywords.add_keyword = [];
          $scope.addKeyword.keywords.$viewValue = '';
          $scope.addKeyword.keywords.$render();
          $scope.keywords.remaining_count = $scope.kw_remaining_temp;
          toastr.warning('Please type atleast a Word');
        }
      }
    };

    $scope.addKeywordToBank = function(params) {
      Business.add_to_keyword_bank(
        {
          id: $scope.business_id
        },
        params,
        function(result) {
          if (result.status === 201) {
            $scope.new_keyword = null;
            $scope.addKeyword.$setPristine();
            // Reset keywords
            $scope.keywords.add_keyword = [];
            $scope.keywords.add_keyword_text = '';
            cleanAndEmptyForm();
            toastr.success('Keyword added to Queue');
            $mdDialog.hide('success');
          }
          if (result.status === 406) {
            $scope.new_keyword = null;
            $scope.keywords.add_keyword = [];
            $scope.keywords.add_keyword_text = '';
            cleanAndEmptyForm();
            $scope.addKeyword.$setPristine();
            // uncheck all input checkbox
            $('.c-list')
              .find('.suggestion-checkbox')
              .prop('checked', false);
            toastr.warning(result.error);
          }
        }
      );
    };

    /**
     * @description Set form and inputs clean and empty
     * @author Jerry
     * @see https://docs.angularjs.org/api/ng/type/ngModel.NgModelController
     */
    function cleanAndEmptyForm() {
      $scope.addKeyword.keywords.$viewValue = '';
      $scope.addKeyword.keywords.$setPristine();
      $scope.addKeyword.keywords.$setValidity(false);
      $scope.addKeyword.keywords.$render();
    }

    /**
     *
     * @use Suggest keyword
     * @param event { Event }
     * @return Suggested keywords { Object }
     */
    $scope.suggestions = [];
    $scope.suggestKeyword = function(event) {
      if (event.type == 'keypress' && event.keyCode != 13) {
        return false;
      }
      $scope.keyword_fetching = true;
      try {
        Business.keyword_suggestions(
          {
            id: $scope.business_id,
            queried_keyword: $scope.searched_keyword
          },
          function(result) {
            $scope.suggestions = result.data;
            $scope.suggestions = _.reject(result.data, function(value) {
              var thisCheck = _.contains(
                $scope.keywords.exisiting_keywords,
                value.keyword_phrase
              );
              return thisCheck;
            });
            $scope.keyword_fetching = false;
          },
          function(error) {
            toastr.error(error.statusText);
            $scope.keyword_fetching = false;
          }
        );
      } catch (e) {
        $scope.suggestions = [];
      }
    };
    // Add checkbox to select all suggested keywords
    // August 27/08/2016
    /**
     * @TODO : selectAllSuggestions and AddKeywordToList can be optimized as
     * single function, skipping it for now
     * @param event
     */
    $scope.selectAllCheckbox = false;
    $scope.selectAllSuggestions = function(event, suggestions) {
      try {
        $scope.selectAllCheckbox = !$scope.selectAllCheckbox;
        if ($scope.selectAllCheckbox) {
          // checked checkbox
          if (
            angular.isDefined(typeof $scope.keywords.add_keyword_text) &&
            $scope.keywords.add_keyword_text !== ''
          ) {
            $scope.keywords.add_keyword_text += '\n';
          } else {
            $scope.keywords.add_keyword_text = '';
          }
          $scope.keywords.add_keyword_text += _.pluck(
            suggestions,
            'keyword_phrase'
          ).join('\n');
          if ($scope.keywords.add_keyword_text.length > 0) {
            $scope.addKeyword.keywords.$setDirty();
            $scope.addKeyword.keywords.$viewValue =
              $scope.keywords.add_keyword_text;
            $scope.addKeyword.keywords.$render();
          }
          $scope.getKeywords(null);
          $('.suggestion-checkbox').prop('checked', true);
        } else {
          // deselect
          $scope.keywords.add_keyword = _.difference(
            $scope.keywords.add_keyword,
            _.pluck(suggestions, 'keyword_phrase')
          );
          $scope.keywords.add_keyword_text = $scope.keywords.add_keyword.join(
            '\n'
          );
          $('.suggestion-checkbox').prop('checked', false);
          if ($scope.keywords.add_keyword_text.length === 0) {
            $scope.addKeyword.keywords.$setPristine();
            $scope.addKeyword.keywords.$setValidity(false);
            $scope.addKeyword.keywords.$viewValue = '';
            $scope.addKeyword.keywords.$render();
          }
        }
      } catch (e) {}
    };
    // eof add checkbox to select all suggested keywords

    $scope.addKeywordToList = function(event, value) {
      if ($(event.target).prop('checked')) {
        // checked add keyword
        if ($scope.keywords.add_keyword_text != '') {
          $scope.keywords.add_keyword_text += '\n' + value.keyword_phrase;
        } else {
          $scope.keywords.add_keyword_text = value.keyword_phrase;
        }
        $scope.getKeywords(null);
      } else {
        $scope.keywords.add_keyword = _.without(
          $scope.keywords.add_keyword,
          value.keyword_phrase
        );
        $scope.keywords.add_keyword_text = $scope.keywords.add_keyword.join(
          '\n'
        );
        $scope.getKeywords(null);
      }
      $scope.addKeyword.keywords.$setDirty(); // Set Form dirty
      if ($scope.keywords.add_keyword_text == '') {
        // If textarea is empty , set form as pristine
        $scope.addKeyword.keywords.$setPristine();
      }
    };
  }
]);
