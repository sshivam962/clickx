clickxApp.controller('QuestionnaireNew', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Questionnaire',
  'Questionnaires',
  'Questions',
  'Question',
  'Groups',
  '$routeParams',
  '$location',
  '$mdDialog',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Questionnaire,
    Questionnaires,
    Questions,
    Question,
    Groups,
    $routeParams,
    $location,
    $mdDialog
  ) {
    $rootScope.current_controller = 'questionnaire';
    $scope.questionnaire = {
      business_id: $routeParams.business_id,
      answers: []
    };
    $scope.answer_group = {};
    $scope.questionnaire_new = true;
    $scope.is_submitted = false;
    $scope.group_field = false;
    var array_group_ids = [];
    var previous_answer = {};
    $scope.business_id = $routeParams.business_id;

    Questions.query({}, function(response) {
      $scope.questions = _.where(response, { is_published: true });
      array_group_ids = _.uniq(_.pluck($scope.questions, 'group_id'));

      Groups.query({}, function(resp) {
        //getting groups which have questions published
        $scope.group_types = _.filter(resp, function(group) {
          return _.contains(array_group_ids, group.id);
        });
        $scope.groups_count = $scope.group_types.length;
      });

      Questionnaire.get({ business_id: $routeParams.business_id }, function(
        response
      ) {
        if (response.status == 200) {
          $scope.questionnaire_created_at = response.questionnaire.created_at;

          _.each($scope.questions, function(question, index) {
            ans =
              _.findWhere(response.answer, { question_id: question.id }) || '';

            if (ans != '' && question.version_no != ans.question_v_id) {
              previous_answer = ans;

              Question.get(
                {
                  id: question.id,
                  version_difference: question.version_no - ans.question_v_id
                },
                function(resp) {
                  latest_question = question;
                  resp.question_of_version_passed.latest_question = question;
                  resp.question_of_version_passed.changed = true;

                  $scope.questions[index] = resp.question_of_version_passed;
                  process_question(latest_question, previous_answer);
                }
              );
            } else {
              process_question(question, ans);
            }
          });
        } else {
          _.each($scope.questions, function(question) {
            $scope.answer_group[question.id] = '';
          });
        }
      });
    });

    process_question = function(question, ans) {
      if (question.exp_ans_type == 'oneliner') {
        $scope.answer_group[question.id] = ans.oneliner || '';
      } else if (question.exp_ans_type == 'boolean_ans') {
        if (ans.boolean_ans == undefined) {
          $scope.answer_group[question.id] = '';
        } else {
          $scope.answer_group[question.id] = ans.boolean_ans.toString();
        }
      } else if (question.exp_ans_type == 'paragraph') {
        $scope.answer_group[question.id] = ans.paragraph || '';
      } else if (question.exp_ans_type == 'mcq') {
        $scope.answer_group[question.id] = ans.mcq || '';
      }
    };

    $scope.validate = function(current_group) {
      questions = _.where($scope.questions, { group_id: current_group.id });
      $.each(questions, function(index, question) {
        if (
          question.exp_ans_type == 'oneliner' &&
          $scope.questionnaireForm[
            'answer_group_' + question.id + '_answer_oneline'
          ].$valid
        ) {
          $scope.group_field = true;
        } else if (
          question.exp_ans_type == 'boolean_ans' &&
          $scope.questionnaireForm[
            'answer_group_' + question.id + '_answer_boolean'
          ].$valid
        ) {
          $scope.group_field = true;
        } else if (
          question.exp_ans_type == 'paragraph' &&
          $scope.questionnaireForm[
            'answer_group_' + question.id + '_answer_paragraph'
          ].$valid
        ) {
          $scope.group_field = true;
        } else if (
          question.exp_ans_type == 'mcq' &&
          $scope.questionnaireForm[
            'answer_group_' + question.id + '_answer_mcq'
          ].$valid
        ) {
          $scope.group_field = true;
        } else {
          $scope.group_field = false;
          toastr.error(
            'Some of the answers are invalid, please correct them',
            'Error'
          );
          return false;
        }
      });
    };

    $scope.validate_chk = function() {
      return $scope.group_field;
    };

    $scope.save_answers = function() {
      if ($scope.questionnaireForm.$valid) {
        $scope.questionnaire.answers.push($scope.answer_group);
        if ($scope.questionnaire_created_at) {
          Questionnaire.update({
            answer: $scope.questionnaire.answers,
            business_id: $scope.questionnaire.business_id
          });
        } else {
          Questionnaires.create({
            answer: $scope.questionnaire.answers,
            business_id: $scope.questionnaire.business_id
          });
        }
        toastr.success('Answers saved successfully', 'Success!');
        // $location.path('/dashboard');
        window.location.href = '/b/dashboard'
      } else {
        toastr.error(
          'Some of the answers are invalid, please correct them',
          'Error'
        );
      }
    };

    var auto_save = function() {
      $scope.questionnaire.answers = [];
      _.forEach($scope.answer_group, function(value, key) {
        if (value == undefined) {
          $scope.answer_group[key] = '';
        }
      });
      $scope.questionnaire.answers.push($scope.answer_group);
      if ($scope.questionnaire_created_at) {
        Questionnaire.update({
          answer: $scope.questionnaire.answers,
          business_id: $scope.questionnaire.business_id
        });
      } else {
        Questionnaires.create({
          answer: $scope.questionnaire.answers,
          business_id: $scope.questionnaire.business_id
        });
      }
    };

    $scope.$on('$locationChangeSuccess', function(event, $scope) {
      auto_save();
      $rootScope.actualLocation = $location.path();
    });

    $scope.view_latest_question = function(question) {
      $scope.latest_quest = question;
      $mdDialog
        .show({
          scope: $scope,
          preserveScope: true,
          clickOutsideToClose: true,
          templateUrl: 'latest_question',
          controller: 'NewController'
        })
        .then(function(result) {}, function(cancel) {})
        .finally(function() {});
    };
  }
]);

clickxApp.controller('NewController', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Questionnaire',
  'Questionnaires',
  'Questions',
  'Question',
  '$routeParams',
  '$location',
  '$mdDialog',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Questionnaire,
    Questionnaires,
    Questions,
    Question,
    $routeParams,
    $location,
    $mdDialog
  ) {
    $scope.save_answer = function() {
      type = $scope.latest_quest.latest_question.exp_ans_type;
      if (type == 'oneliner') {
        type = '_answer_oneline';
      } else if (type == 'paragraph') {
        type = '_answer_paragraph';
      } else if (type == 'boolean_ans') {
        type = '_answer_boolean';
      } else if (type == 'mcq') {
        type = '_answer_mcq';
      }
      if (
        $scope.qForm[
          'answer_group_' + $scope.latest_quest.latest_question.id + type
        ].$valid
      ) {
        $mdDialog.hide();
      }
    };

    $scope.closeModal = function() {
      $mdDialog.cancel('cancel');
    };
  }
]);
