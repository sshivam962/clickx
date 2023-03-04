clickxApp.controller('Leads', [
  '$scope',
  '$rootScope',
  '$http',
  '$resource',
  'Business',
  '$location',
  '$modal',
  '$routeParams',
  '$resource',
  function(
    $scope,
    $rootScope,
    $http,
    $resource,
    Business,
    $location,
    $modal,
    $routeParams,
    $resource
  ) {
    $scope.business_id = $scope.business_id || $routeParams.business_id;

    $scope.init_lead_page_configs = function () {
      $scope.leadsByPage = 5;
      $scope.leads_per_page = 10;
      $scope.detailed_lead = '';
      $rootScope.current_controller = 'home';
      $scope.page = $scope.leads_count = 0;
    };
    $scope.init_lead_page_configs();
    Business.get({ id: $routeParams.business_id }, function (business) {
      $scope.business = business;
    });
    $scope.paginate_leads = function() {
      $scope.get_page_leads();
    };
    $scope.get_page_leads = function() {
      begin = ($scope.current_page - 1) * $scope.leads_per_page;
      end = begin + $scope.leads_per_page;
      $scope.current_page_leads = $scope.leads.slice(begin, end);
    };
  }
]);
/**
 * LEAD BETA
 */

clickxApp.controller('LeadController', [
  '$scope',
  'LeadAPIService',
  '$routeParams',
  '$rootScope',
  '$localStorage',
  '$mdDateRangePicker',
  '$timeout',
  '$filter',
  '$mdSidenav',
  function(
    $scope,
    LeadAPIService,
    $routeParams,
    $rootScope,
    $localStorage,
    $mdDateRangePicker,
    $timeout,
    $filter,
    $mdSidenav
  ) {
    'use strict';

    $scope.contact_filter = $localStorage.smartFilter || [];
    $scope.lead = {}

    $scope.columns = $localStorage.$default({
      order: [
        [
          '<b><input class=\'add-current-listbox\' type=\'checkbox\' ng-click=\'addAllListedLeads($event)\'></input></b>',
          'show_check',
          'check'
        ],
        [
          '<u class="draggable" title="Name of the contact"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.fname === true, sortdesc: sort_order.fname === false}"> Name </a></u>',
          'show_name',
          'fname',
          ''
        ],
        [
          '<u class="draggable" title="Email of the contact"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.email === true, sortdesc: sort_order.email === false}"> Email </a></u>',
          'show_email',
          'email',
          ''
        ],
        [
          '<u class="draggable" title="Phone of the contact"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.phone === true, sortdesc: sort_order.phone === false}"> Phone </a></u>',
          'show_phone',
          'phone',
          'min-width: 100px;'
        ],
        [
          '<u class="draggable" title="Status of the contact"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.status === true, sortdesc: sort_order.status === false}"> Status </a></u>',
          'show_status',
          'status',
          'min-width: 100px;'
        ],
        [
          '<u class="draggable" title="Country of the contact"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.nationality === true, sortdesc: sort_order.nationality === false}"> Country </a></u>',
          'show_nationality',
          'nationality',
          'min-width: 99px;'
        ],
        [
          '<u class="draggable" title="Organization of the contact"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.organization === true, sortdesc: sort_order.organization === false}"> Organization </a></u>',
          'show_organization',
          'organization',
          'min-width: 138px;'
        ],
        [
          '<u class="draggable" title="Source from where the contacts signed up to your site"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.utm_source === true, sortdesc: sort_order.utm_source === false}"> Source </a></u>',
          'show_utm_source',
          'utm_source',
          'min-width: 90px;'
        ],
        [
          '<u class="draggable" title="Source from where the contacts is created"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.source === true, sortdesc: sort_order.source === false}"> Conversion Type </a></u>',
          'show_source',
          'source',
          'min-width: 155px;'
        ],
        [
          '<u class="draggable" title="Total Revenue"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.total_revenue === true, sortdesc: sort_order.total_revenue === false}"> Total Revenue </a></u>',
          'show_total_revenue',
          'total_revenue'
        ],
        [
          '<u class="draggable" title="Time and date when the contact details were updated recently"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.created_at === true, sortdesc: sort_order.created_at === false}"> Created At </a></u>',
          'show_created_at',
          'created_at',
          'min-width: 113px;'
        ],
        [
          '<u class="draggable" title="Time and date when the contact details were updated recently"><a class="draggable sort-by" ng-class = "{sortasc: sort_order.updated_at === true, sortdesc: sort_order.updated_at === false}"> Updated At </a></u>',
          'show_updated_at',
          'updated_at',
          'min-width: 118px;'
        ]
      ]
    });

    $scope.getSourceHtml = function(lead) {
      if (lead.source == 'form_submission') {
        return '<span title="Form Submission"><i class="fa fa-file-text-o"></i></span>';
      }
      if (lead.source == 'manual') {
        return '<span title="Manual"><i class="fa fa-hand-paper-o"></i></span>';
      }
      if (lead.source == 'phone_call') {
        return (
          '<a class="text-info" href="/#/calls" ' +
          'title="Phone Call"><i class="fa fa-phone info"></i></a>'
        );
      }
    };

    $scope.generatedRow = function(lead) {
      $scope.this_lead = lead;
      var check =
          '<input class="lead-checkbox" type="checkbox" ng-value="this_lead.id" ng-click="addLeads($event,' +
          lead.id +
          ')" name="leads"></input>',
        fname =
          '<a class="l-grey" href="/#/live/' +
          $rootScope.current_business +
          '/tracking/user/' +
          lead.id +
          '"><div class="contact--details"><div class="contact--details__logo"><text-logo class="default-logo-style" logo=' +
          lead.avatar.url +
          ' subtext="' +
          $filter('fullName')(lead) +
          '" style="{{textlogostylesm}}"></text-logo></div><div class="contact--details__name">' +
          $filter('fullName')(lead) +
          '</div></div></a>',
        email =
          '<a class="l-grey" href="/#/live/' +
          $rootScope.current_business +
          '/tracking/user/' +
          lead.id +
          '"> ' +
          (lead.email || ' NA ') +
          ' </a>',
        phone = lead.phone || ' NA ',
        status = $filter('humanize')(lead.status) || ' NA ',
        nationality = lead.nationality || ' NA ',
        organization = lead.organization || ' NA ',
        utm_source = $filter('humanize')(lead.utm_source) || ' NA ',
        source = $scope.getSourceHtml(lead),
        total_revenue = lead.total_revenue || ' NA ',
        created_at =
          $filter('fromNowMoment')(lead.created_at) +
          $filter('usaDateFormat')(lead.created_at, '(', ')'),
        updated_at =
          $filter('fromNowMoment')(lead.updated_at) +
          $filter('usaDateFormat')(lead.updated_at, '(', ')');
      return {
        check: check,
        fname: fname,
        email: email,
        phone: phone,
        status: status,
        nationality: nationality,
        organization: organization,
        utm_source: utm_source,
        source: source,
        total_revenue: total_revenue,
        created_at: created_at,
        updated_at: updated_at
      };
    };

    $scope.dropSuccess = function(e, item, collection) {
      $scope.columns = $localStorage.$default({ order: collection });
    };

    $scope.initial = true;
    $scope.leadsUsers = [];
    $scope.selectedLeads = [];
    $scope.sort_order = {
      fname: '',
      email: '',
      phone: '',
      status: '',
      utm_source: '',
      organization: '',
      nationality: '',
      source: '',
      total_revenue: '',
      created_at: '',
      updated_at: ''
    };

    $scope.toggleSmartFilter = function(componentId, clear) {
      $mdSidenav(componentId).toggle();
      if (clear) {
        $scope.contact_filter = [];
        $scope.$broadcast('triggerSTTable');
      }
    };

    $scope.toggle = function(item) {
      var index = _.findIndex($scope.contact_filter, item);
      if (index > -1) {
        $scope.contact_filter.splice(index, 1);
      } else {
        $scope.contact_filter.push(item);
      }
    };

    $scope.exists = function(item) {
      return _.findIndex($scope.contact_filter, item) > -1;
    };

    var params = {};
    $scope.sort_by = '-updated_at';
    params.business_id = $rootScope.current_business;
    $scope.rp_date = $rootScope.date || {
      startDate: moment()
        .startOf('month')
        .format('YYYY-MM-DD'),
      endDate: moment().format('YYYY-MM-DD')
    };

    if ($routeParams.status) {
      params['contact_status'] = $routeParams.status;
    } else {
      if (params['contact_status']) {
        delete params['contact_status'];
      }
    }

    $scope.column_select = $localStorage.$default({
      leads_column_select: {
        show_check: true,
        show_name: true,
        show_email: true,
        show_phone: true,
        show_status: true,
        show_nationality: true,
        show_organization: false,
        show_utm_source: true,
        show_source: true,
        show_total_revenue: true,
        show_created_at: true,
        show_updated_at: false
      }
    });

    $scope.dateChangeDetect = false;
    $scope.changeCurrentDate = function($event) {
      $mdDateRangePicker
        .show({
          model: $rootScope.selectedRange,
          autoConfirm: true,
          customTemplates: $rootScope.mdCustomTemplates,
          showTemplate: true,
          isDisabledDate: $rootScope.isFutureDate
        })
        .then(function(result) {
          if (result) {
            $scope.initial = false;
            $rootScope.selectedRange = result;
            $scope.rp_date = {
              startDate: moment(result.dateStart).format('YYYY-MM-DD'),
              endDate: moment(result.dateEnd).format('YYYY-MM-DD')
            };
            params['start_date'] = moment($scope.rp_date.startDate).format(
              'DD-MM-YYYY'
            );
            params['end_date'] = moment($scope.rp_date.endDate).format(
              'DD-MM-YYYY'
            );
            $rootScope.date = $scope.rp_date;

            $scope.date_range = {
              startDate: moment(result.dateStart).format('MMM DD, YYYY'),
              endDate: moment(result.dateEnd).format('MMM DD, YYYY')
            };

            $scope.dateChangeDetect = true;
            $scope.$broadcast('triggerSTTable');
          }
        });
    };
    $scope.sortBy = function(param) {
      if (param != 'check') {
        for (var key in $scope.sort_order) {
          if (key != param) {
            $scope.sort_order[key] = '';
          }
        }
        $scope.sort_order[param] = !$scope.sort_order[param];
        $scope.sort_by = $scope.sort_order[param] ? param : '-' + param;
        $scope.$broadcast('triggerSTTable');
      }
    };
    $scope.select_status = ['all', 'contact', 'customer', 'lead'];

    $scope.clearDateRange = function() {
      delete params.start_date;
      delete params.end_date;
      $scope.initial = true;
      $scope.$broadcast('triggerSTTable');
    };

    /**
     *
     * @param tableState
     */
    $scope.fetchLeadData = function(tableState) {
      $scope.tableState = tableState || {};
      var currentPage =
        tableState.pagination.start / tableState.pagination.number;
      params['page'] = currentPage + 1 || 1;
      params['per_page'] = tableState.pagination.number || 10;
      params['page[number]'] = params.page;
      params['page[size]'] = params.per_page;
      if ($scope.dateChangeDetect) {
        params['page[number]'] = 1;
        params['page[size]'] = 10;
        tableState.pagination.start = 0;
        $scope.dateChangeDetect = false;
      }
      if ($scope.contact_filter.length) {
        params['filter'] = angular.toJson($scope.contact_filter);
        $localStorage.$default({
          smartFilter: $scope.contact_filter
        });
      } else {
        delete $localStorage.smartFilter;
        delete params['filter'];
      }
      // Search
      if (
        tableState.search &&
        tableState.search.predicateObject &&
        tableState.search.predicateObject.$
      ) {
        params['search'] = tableState.search.predicateObject.$;
      } else {
        if (params['search']) delete params['search'];
      }
      delete params.per_page;
      delete params.page;
      if (tableState.sort) {
        if (tableState.sort.predicate) {
          params['sort'] =
            (tableState.sort.reverse ? '-' : '') + tableState.sort.predicate;
        } else {
          delete params['sort'];
        }
      }
    };
    $scope.selectedIndex = 0;

    $scope.filters = {
      source: ['google', 'facebook', 'github'],
      status: ['lead', 'contact', 'customer'],
      conversion_type: ['phone_call', 'form_submission', 'manual'],
    };

    $scope.errorHandle = function (error) {
      toastr.error(error.messages);
    };

    $scope.filterContactList = function () {
      $scope.$broadcast('triggerSTTable');
    };

    /**
     *
     * @param event
     * @param key
     */
    $scope.addLeads = function (event, key) {
      $('.add-current-listbox').prop('checked', false);
      var element = $(event.target);
      if (element.prop('checked')) {
        $scope.selectedLeads.push(key);
      } else {
        $scope.selectedLeads = _.without($scope.selectedLeads, key);
      }
      $scope.selectedLeads = _.uniq($scope.selectedLeads);
    };

    /**
     *
     * @param event
     * @returns {boolean}
     */
    $scope.deleteLeads = function (event) {
      params['page[size]'] = 10;
      params['page[number]'] = 1;
      event.preventDefault();
      if ($scope.selectedLeads.length === 0) {
        toastr.warning('Please select leads');
        return false;
      }
      if ($scope.selectedLeads.length == 1) {
        LeadAPIService.remove(
          {
            business_id: $rootScope.current_business,
            id: $scope.selectedLeads[0],
          },
          $scope.reloadList,
          function (error) {
            toastr.error(error.statusText);
          }
        );
      } else {
        LeadAPIService.destroy_multiple(
          {
            business_id: $rootScope.current_business,
            'leads[]': $scope.selectedLeads,
          },
          $scope.reloadList,
          function (error) {
            toastr.error(error.statusText);
          }
        );
      }
    };

    $scope.reloadList = function () {
      $timeout(function () {
        $('.lead-checkbox').each(function () {
          $(this).attr('checked', false);
        });
        toastr.success('Contact(s) deleted.', 'Success');
        $scope.$broadcast('triggerSTTable');
        $scope.selectedLeads = []; //clear selected leads
      });
    };

    /**
     *
     * @param event
     */
    $scope.addAllListedLeads = function (event) {
      var currentElement = $(event.target);
      if (currentElement.prop('checked')) {
        $('.lead-checkbox').prop('checked', true);
        $scope.selectedLeads = _.pluck($scope.leadsUsers, 'id');
      } else {
        $('.lead-checkbox').prop('checked', false);
        $scope.selectedLeads = [];
      }
    };

    $scope.textlogostyle = {
      hlogo: '50',
      wlogo: '50',
      height: '60',
      width: '60',
      cx: '27',
      cy: '27',
      r: '25',
      font_size: '15',
      x: '16',
      y: '32'
    };
  }
]);
