clickxApp.controller('BusinessOnboardingProcedures', [
  '$scope',
  '$routeParams',
  '$rootScope',
  '$location',
  '$route',
  'Onboarding',
  function($scope, $routeParams, $rootScope, $location, $route, Onboarding) {
    $scope.progress_percentage = null;
    $scope.remaining_tasks_count = null;

    $scope.fetchBusinessOnboardingProcedures = function() {
      Onboarding.query({}, function(response) {
        $scope.biz_onboarding_procedures = response.data;
        $.each($scope.biz_onboarding_procedures, function(i, procedure) {
          procedure['progress_percentage'] = $scope.calculateProgressPercentage(
            procedure,
            procedure.tasks
          );
          procedure[
            'remaining_tasks_count'
          ] = $scope.calculateRemainingTasksCount(procedure, procedure.tasks);
        });
      });
    };

    $scope.getBusinessOnboardingProcedure = function(id) {
      Onboarding.get({ id: id }, function(response) {
        $scope.onboarding_procedure = response.data;
        $scope.tasks = $scope.onboarding_procedure.tasks;
        $scope.tasks_count = $scope.tasks.length;
        $scope.calculateProgressPercentage($scope.tasks);
        $scope.calculateRemainingTasksCount($scope.tasks);
      });
    };

    $scope.taskCompleted = function(procedure, task) {
      Onboarding.toggle_status({ id: task.id }, function(response) {
        if (response.status == 200) {
          updated_task = response.data;
          $.each($scope.tasks, function(i, t) {
            if (t.id == task.id) {
              var status =
                typeof updated_task.completed != 'undefined'
                  ? String(updated_task.completed) == 'true'
                  : false;

              if (status) {
                t['completed'] = true;
                $('#task' + task.id).removeClass('fa-circle-o');
                $('#task' + task.id).addClass('fa-check-circle');
              } else {
                t['completed'] = false;
                $('#task' + task.id).removeClass('fa-check-circle');
                $('#task' + task.id).addClass('fa-circle-o');
              }
            }
          });
          $scope.calculateProgressPercentage(procedure, $scope.tasks);
          $scope.calculateRemainingTasksCount(procedure, $scope.tasks);
        }
      });
    };

    $scope.calculateProgressPercentage = function(procedure, tasks) {
      procedure.progress_percentage =
        100 * ($scope.completedTasksCount(tasks) / tasks.length);
      return procedure.progress_percentage;
    };

    $scope.calculateRemainingTasksCount = function(procedure, tasks) {
      procedure.remaining_tasks_count =
        tasks.length - $scope.completedTasksCount(tasks);
      return procedure.remaining_tasks_count;
    };

    $scope.completedTasksCount = function(tasks) {
      completed_tasks_count = 0;
      $.each(tasks, function(i, t) {
        if (t.completed) {
          completed_tasks_count++;
        }
      });
      return completed_tasks_count;
    };

    if ($routeParams.id) {
      $scope.getBusinessOnboardingProcedure();
    } else {
      $scope.fetchBusinessOnboardingProcedures();
    }
  }
]);
