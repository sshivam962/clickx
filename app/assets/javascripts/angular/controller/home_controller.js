clickxApp.controller('Home', [
    '$scope',
    '$rootScope',
    '$http',
    '$resource',
    '$location',
    'Users',
    '$route',
    '$cookieStore',
    'Business',
    '$window',
    'User',
    'Businesses',
    '$sce',
    '$templateRequest',
    '$compile',
    'Agency',
    'Agencies',
    '$q',
    function(
        $scope,
        $rootScope,
        $http,
        $resource,
        $location,
        Users,
        $route,
        $cookieStore,
        Business,
        $window,
        User,
        Businesses,
        $sce,
        $templateRequest,
        $compile,
        Agency,
        Agencies,
        $q
    ) {
        $rootScope.date_range = {};
        $rootScope.dashboard_url = dashboard_url;
        $rootScope.current_role = current_role;
        $rootScope.current_business = current_business;
        $rootScope.is_business_user = is_business_user;
        $rootScope.is_agency_admin_user = is_agency_admin;
        $rootScope.is_system_user = is_system_user;
        $rootScope.onboarding = false;
        $rootScope.textlogostyle = {
            hlogo: '70',
            wlogo: '70',
            height: '75',
            width: '75',
            cx: '37',
            cy: '37',
            r: '35',
            font_size: '25',
            x: '21',
            y: '47'
        };

        $rootScope.textlogostylesm = {
            hlogo: '27',
            wlogo: '27',
            height: '30',
            width: '30',
            cx: '14',
            cy: '14',
            r: '14',
            font_size: '12',
            x: '5',
            y: '18'
        };


        $rootScope.business_reviews_url = business_reviews_url;
        $rootScope.is_super_admin = is_super_admin;
        $rootScope.current_user_id = current_id;
        $rootScope.current_user_unique_id = current_user_unique_id;
        $rootScope.current_user_email = current_user_email;
        $rootScope.current_user_logo = current_user_logo;
        $rootScope.current_user_initials = current_user_initials;
        $rootScope.current_user_name = current_user_name;
        $rootScope.current_agency_id = current_agency;
        $rootScope.current_agency_name = current_agency_name;
        $rootScope.current_agency_level = current_agency_level;
        $rootScope.agency_square_logo = square_logo;
        $rootScope.agency_logo = logo;
        $rootScope.current_controller = 'home';
        $rootScope.current_logo = "";
        $rootScope.seo_auth_token = seo_auth_token;
        $rootScope.video_seen = $cookieStore.get('video_seen');
        $rootScope.agency_admins = [];
        $rootScope.subscription_plans_available = subscription_plans_available;



        $rootScope.demo_login =
            typeof demo_login != 'undefined' ?
            String(demo_login) == 'true' :
            false;
        $rootScope.custom_packages_present =
            typeof custom_packages_present != 'undefined' ?
            String(custom_packages_present) == 'true' :
            false;
        $rootScope.business_have_my_quotes =
            typeof business_have_my_quotes != 'undefined' ?
            String(business_have_my_quotes) == 'true' :
            false;

        $rootScope.is_agency_active =
            typeof is_agency_active != 'undefined' ?
            String(is_agency_active) == 'true' :
            false;

        $rootScope.all_ownable_businesses = [];

        $rootScope.app_name = app_name;
        $rootScope.branded = typeof branded != 'undefined' ? branded : false;
        $rootScope.business_is_trial =
            typeof current_business_trial_service != 'undefined' ?
            String(current_business_trial_service) == 'true' :
            false;
        $rootScope.intelligence_enabled =
            typeof current_intelligence_enabled != 'undefined' ?
            String(current_intelligence_enabled) == 'true' :
            false;
        $rootScope.free_service =
            typeof current_business_free_service != 'undefined' ?
            String(current_business_free_service) == 'true' :
            false;
        $rootScope.has_onboarding_procedures =
            typeof has_onboarding_procedures != 'undefined' ?
            String(has_onboarding_procedures) == 'true' :
            false;
        $rootScope.export_disabled =
            typeof export_disabled != 'undefined' ?
            String(export_disabled) == 'true' :
            false;
        $rootScope.preview_user =
            typeof preview_user != 'undefined' ?
            String(preview_user) == 'true' :
            false;
        $rootScope.semrush_project =
            typeof semrush_project != "undefined"
              ? String(semrush_project) == "true"
              : false;
        $rootScope.show_chat_box = false;
        $rootScope.qn_content = null;

        $rootScope.user_permissions =
            typeof user_permissions != 'undefined' ?
            user_permissions.split(',') : [];

        $rootScope.a_enabled_packages =
            typeof agency_enabled_packages != 'undefined' ?
            agency_enabled_packages.split(',') : [];
        $rootScope.a_digital_pr_enabled =
            typeof a_digital_pr_enabled != 'undefined' ?
            String(a_digital_pr_enabled) == 'true' :
            false;
        $rootScope.a_social_media_enabled =
            typeof a_social_media_enabled != 'undefined' ?
            String(a_social_media_enabled) == 'true' :
            false;
        $rootScope.case_study_enabled =
            typeof case_study_enabled != 'undefined' ?
            String(case_study_enabled) == 'true' :
            false
        $rootScope.agreement_signed =
            typeof agreement_signed != 'undefined' ?
            String(agreement_signed) == 'true' :
            false;
        $scope.showChatBox = function() {
            $rootScope.show_chat_box = !$rootScope.show_chat_box;
            if ($rootScope.show_chat_box) {
                $('#livechat').show('medium');
                $('#chat-icon').text('close');
            } else {
                $('#livechat').hide('medium');
                $('#chat-icon').text('chat');
            }
        };

        $scope.sendSupportEmail = function(qn_content) {
            if (qn_content) {
                Businesses.send_support_email({ content: qn_content }, function(resp) {
                    if (resp.status == 200) {
                        toastr.success(
                            'Your query has been submitted. Our support team will get back to you soon!!!'
                        );
                        $rootScope.show_chat_box = false;
                        $rootScope.qn_content = null;
                        $('#livechat').hide('medium');
                        $('#chat-icon').text('chat');
                    }
                });
            } else {
                toastr.error('Please add a question.');
            }
        };

        $scope.getCurrentAgency = function() {
            if ($rootScope.current_agency_id.trim().length > 0) {
                Agency.show({ id: $rootScope.current_agency_id }, function(resp) {
                    $rootScope.current_agency = resp;
                });
            }
        };

        $scope.getCurrentBusinessUsers = function() {
            Users.get_business_users({}, function(resp) {
                $rootScope.current_business_users = resp;
            });
        };

        $scope.getCurrentAgency();
        if (is_business_user) {
            $scope.getCurrentBusinessUsers();
        }

        $scope.clickDisabledBtn = function(e) {
            if (e.currentTarget.classList.contains('side-menu-disable')) {
                if ($rootScope.free_service) {
                    // $templateRequest('themeX/home/_time_schedule.html', false).then(
                    //   function(html) {
                    //     var timeScheduleEle = angular.element(html);
                    //     $('body').append(timeScheduleEle);
                    //     $compile(timeScheduleEle)($scope);
                    //     $(timeScheduleEle).modal('show');
                    //     $scope.closeModal = function() {
                    //       $(timeScheduleEle).modal('hide');
                    //     };
                    //   }
                    // );
                }
                e.preventDefault();
                e.stopPropagation();
            }
        };

        $rootScope.ProgressVal = parseFloat(
            (
                (parseInt(moment().format('D')) /
                    parseInt(
                        moment()
                        .endOf('month')
                        .format('D')
                    )) *
                100
            ).toFixed(1)
        );

        $rootScope.currentStyle = {
            backgroundColor: '#F8B018'
        };

        $scope.maxStyle = {
            backgroundColor: '#3e4050'
        };

        /**
         *  Angular UI Bootstrap has modal directive, first we need to check
         *  whether it is a first time user and show the intro video
         */
        $scope.first_time_user = current_user_sign_in_count <= 1;

        if (
            $rootScope.business_is_trial &&
            $scope.first_time_user &&
            !$rootScope.video_seen
        ) {
            if (typeof window.alreadyModal == 'undefined') {
                $templateRequest('home/_video_modal.html', false).then(function(html) {
                    var videoIntroEle = angular.element(html);
                    $('body').append(videoIntroEle);
                    $compile(videoIntroEle)($scope);
                    $(videoIntroEle).modal('show');
                    $scope.closeModal = function() {
                        $(videoIntroEle).modal('hide');
                    };
                    $(videoIntroEle).on('shown.bs.modal', function() {
                        $(videoIntroEle)
                            .find('iframe')
                            .load(function() {
                                $(videoIntroEle)
                                    .find('.show-loading')
                                    .remove();
                            });
                    });
                    $(videoIntroEle).on('hidden.bs.modal', function() {
                        $cookieStore.put('video_seen', true);
                    });
                });
            }
            window.alreadyModal = true;
        }

        $scope.go = function(path) {
            $location.path(path);
        };

        $scope.go_back = function() {
            $window.history.back();
        };

        assign_user_vars = function(business) {
            $cookieStore.put('current_business_id', business.id);
            $rootScope.dummy_business = dummy_business = business.dummy;
            $rootScope.is_managed_service = current_managed_service;
            $rootScope.selected_business = selected_business = business;
            $rootScope.current_call_analytics = current_call_analytics_id =
                business.call_analytics_id;
            $rootScope.current_google_analytics_id = current_google_analytics_id =
                business.google_analytics_id;
            $rootScope.current_site_url = current_site_url;
            $rootScope.adword_client_id = current_adword_client_id =
                business.google_ads_customer_client_id;
            $rootScope.current_facebook_ad_account_id = current_facebook_ad_account_id =
                business.fb_ad_account_id;
            $rootScope.current_callrail_client_id = current_callrail_client_id =
                business.callrail_id;

            $rootScope.local_profile_enabled = current_local_profile_enabled = (
                business.local_profile_service == true
            ).toString();
            $rootScope.seo_reports_enabled = current_seo_enabled = (
                business.seo_service == true
            ).toString();
            $rootScope.site_audit_enabled = current_site_audit_enabled = (
                business.site_audit_service == true
            ).toString();
            $rootScope.call_analytics_enabled = current_calls_enabled = (
                business.call_analytics_service == true
            ).toString();
            $rootScope.google_analytics_enabled = 'true';
            $rootScope.contents_enabled = current_contents_enabled = (
                business.contents_service == true
            ).toString();
            $rootScope.leads_enabled = 'true';
            $rootScope.trial_service_enabled = current_trial_service_enabled = (
                business.trial_service == true
            ).toString();
            $rootScope.search_console_enabled = 'true';
            $rootScope.current_logo = business.logo;
            $rootScope.reviews_enabled = 'true';
            $rootScope.backlink_service_enabled =
              current_backlink_service_enabled = (
                business.backlink_service == true
              ).toString();
            $rootScope.managed_ppc_service_enabled = current_managed_ppc_service_enabled = (
                business.managed_ppc_service == true
            ).toString();
            $rootScope.current_business = business.id;
            $rootScope.live_tracking_enabled = 'true';
            $rootScope.offer_enabled = 'true';
            $rootScope.business_reviews_url = business_reviews_url;
            $rootScope.competitors_service = $scope.competitors_service = current_competitors_service = (
                business.competitors_service == true
            ).toString();
            $rootScope.reputation_service = current_reputation_service;
            $rootScope.app_name = app_name;
            $rootScope.is_dummy_business = business.dummy;
            $scope.facebook_ad_enabled = current_facebook_ad_service = (
                business.facebook_ad_service == true
            ).toString();
        };

        $scope.header_unique_id = function() {
            if ($rootScope.selected_business != undefined) {
                return $rootScope.selected_business.unique_id; // + ' : ' + $rootScope.current_user_unique_id;
            } else {
                return $rootScope.current_user_unique_id;
            }
        };

        $scope.is_admin_session = function() {
            return (
                $cookieStore.get('admin_id') != undefined &&
                $cookieStore.get('admin_id') != ''
            );
        };

        $scope.is_agency_admin = function() {
            return (
                $cookieStore.get('agency_admin_id') != undefined &&
                $cookieStore.get('agency_admin_id') != ''
            );
        };

        $scope.sign_out = function() {
            User.sign_out({}, function(response) {
                window.location = '/users/sign_in';
            });
            return;
        };

        $rootScope.$on('$includeContentLoaded', function() {
            $rootScope.opened_business_id = '';
        });

        $rootScope.resizeChart = function(divId) {
            setTimeout(function() {
                try {
                    var chart = $('#' + divId).highcharts();
                    var height = $(chart.container.parentElement).height();
                    var width = $(chart.container.parentElement).width();
                    chart.setSize(width, height);
                } catch (e) {
                    //console.log(e)
                }
            }, 5);
        };

        $rootScope.initializeBusiness = function(business) {
            $scope.business = business;
            $rootScope.business = business;
            $scope.getSupportMembersName();
            assign_user_vars(business);
            $scope.remaining_days = business.remaining_days;
        };

        $scope.getSupportMembersName = function() {
            $scope.support_members_name = $rootScope.business.support_members
                .map(a => a.name)
                .join(', ');
        };

        $rootScope.fetchKeywordRanking = function(params) {
            $rootScope.keywordResult = Business.business_keywords(params);
        };

        $rootScope.set_business = function(biz_id) {
            if (angular.isNumber(biz_id) || biz_id.trim().length > 0) {
                Business.get({ id: biz_id }, function(response) {
                    $rootScope.initializeBusiness(response);
                });
            }
        };

        $rootScope.set_business(current_business);

        $rootScope.login_to_dashboard = function(params) {
            if ($scope.current_role == 'admin' || $scope.current_role == 'agency_admin') {
                $window.location.href = '/switch_to_business_user?' + jQuery.param(params);
            } else {
                $rootScope.flash = {};
                $rootScope.flash.message = 'Access Denied';
                $location.path('/businesses');
            }
        };

        $scope.mapTM = function(map) {
            if ($rootScope.branded) {
                var clickxTM = document.createElement('div');
                clickxTM.style.background = 'white';
                clickxTM.style.padding = '5px';
                clickxTM.innerHTML =
                    'Powered By ' +
                    "<img src='https://s3.amazonaws.com/clickx-images/Clickx-Logo.png' type='image/png' style='height:auto;width:60px'></img>";

                map.controls[google.maps.ControlPosition.TOP_RIGHT].push(clickxTM);
            }
        };

        $scope.trustSrc = function(src) {
            return $sce.trustAsResourceUrl(src);
        };

        $scope.agencyUsers = function() {
            Agencies.agency_admins({ id: current_agency }, function(data) {
                $rootScope.agency_admins = data;
            });
        };

        if ($scope.is_admin_session && current_agency && !current_business) {
            $scope.agencyUsers();
        }

        $scope.getCountryFromLocale = function(locale) {
            country = 'United States - English';
            $.each($rootScope.countryList, function(i, locale_info) {
                if (locale == locale_info.locale) {
                    country = locale_info.country;
                }
            });
            return country.split('-')[0].trim() || 'United States';
        };

        $scope.getCountryCodeFromLocale = function(locale) {
            if (locale) return locale.split('-')[1].trim() || 'us';
        };

        $scope.getCountryLocale = function(business) {
            Business.country_locale(function(response) {
                $rootScope.countryList = response.data;
                if (business.locale) {
                    var locale = _.find($rootScope.countryList, function(res) {
                        return res.locale == business.locale;
                    });
                    business.locale = locale;
                    $scope.options1 = {
                        types: '(regions)',
                        country: $scope.getCountryCodeFromLocale(business.locale.locale)
                    };
                }
            });
        };

        $scope.setTargetCityForCountry = function(business) {
            country = $scope.getCountryFromLocale(business.locale.locale);
            country_code = $scope.getCountryCodeFromLocale(business.locale.locale);
            business.target_city = country;
            $scope.options1 = {
                types: '(regions)',
                country: country_code
            };
        };
    }
]);

clickxApp.controller('SetBusiness', [
    '$scope',
    '$rootScope',
    '$http',
    '$resource',
    'User',
    '$location',
    '$routeParams',
    '$mdDialog',
    'Business',
    'Users',
    function(
        $scope,
        $rootScope,
        $http,
        $resource,
        User,
        $location,
        $routeParams,
        $mdDialog,
        Business,
        Users
    ) {
        $scope.current_user_businesses = $rootScope.current_user_businesses;

        $scope.change_business = function() {
            if ($scope.userForm.$valid) {
                if (
                    $scope.new_business.trial_service == true &&
                    $scope.new_business.remaining_days <= 0
                ) {
                    toastr.error(
                        'Your trial period is over. Contact your account manager to re-activate the account.',
                        'Sorry!'
                    );
                } else {
                    Users.set_business({ business_id: $scope.new_business.id },
                        function(response) {
                            Business.current_business_dashboard({}, function(resp) {
                                window.location.href = resp.data.url;
                                window.location.reload();
                            });
                            $mdDialog.hide(response);
                        },
                        function(error) {
                            console.log(error);
                        }
                    );
                }
            }
        };

        $scope.closeModal = function() {
            $mdDialog.cancel('cancel');
        };
    }
]);

clickxApp.controller('SetOwnableBusiness', [
    '$scope',
    '$rootScope',
    '$http',
    '$resource',
    'User',
    '$location',
    '$routeParams',
    '$mdDialog',
    'Business',
    'Users',
    '$window',
    function(
        $scope,
        $rootScope,
        $http,
        $resource,
        User,
        $location,
        $routeParams,
        $mdDialog,
        Business,
        Users,
        $window
    ) {
        $scope.all_ownable_businesses = $rootScope.all_ownable_businesses;

        $scope.change_ownable_business = function() {
            if ($scope.new_ownable_business != undefined) {
                $window.location.href =
                    '/switch_to_business_user?business_id=' +
                    $scope.new_ownable_business.id;
            }
            $mdDialog.hide();
        };

        $scope.closeModal = function() {
            $mdDialog.cancel('cancel');
        };
    }
]);

/**
 * @description Special controller for managing
 */
clickxApp.controller('ThemeXHeaderController', [
    '$scope',
    '$rootScope',
    '$mdDialog',
    '$cookieStore',
    'Users',
    'Businesses',
    function($scope, $rootScope, $mdDialog, $cookieStore, Users, Businesses) {
        // $scope.$on('call_select_campaign', function(){
        //   $scope.select_campaign();
        // });
        $rootScope.current_user_id = current_id;
        $rootScope.is_managed_service = current_managed_service;
        $rootScope.is_system_user = is_system_user;
        $scope.select_campaign = function(e) {
            if (typeof e !== 'undefined') e.preventDefault();
            $scope.new_business_id = $cookieStore.get('current_business_id') || '';

            Users.get_businesses({ user_id: $rootScope.current_user_id }, function(
                response
            ) {
                $rootScope.current_user_businesses = response;
                $mdDialog.show({
                    templateUrl: 'changeBusiness',
                    controller: 'SetBusiness'
                });
            });
        };

        $scope.select_ownable_business = function(e) {
            if (typeof e !== 'undefined') e.preventDefault();

            Businesses.get_all_ownable_businesses(function(result) {
                $rootScope.all_ownable_businesses = result;
                $mdDialog.show({
                    templateUrl: 'selectBusiness',
                    controller: 'SetOwnableBusiness',
                    escapeToClose: false
                });
            });
        };
    }
]);

clickxApp.controller('ThemeXSidebarController', [
    '$scope',
    '$rootScope',
    '$mdDialog',
    '$templateRequest',
    '$compile',
    'Business',
    '$window',
    function(
        $scope,
        $rootScope,
        $mdDialog,
        $templateRequest,
        $compile,
        Business,
        $window
    ) {
        $rootScope.non_managed_client_user = ($rootScope.is_system_user && $rootScope.is_managed_service == 'true') || ($rootScope.is_managed_service != 'true')

        $scope.clickDisabledBtn = function(e, field) {
            if (e.currentTarget.classList.contains('show_popup')) {
                if ($rootScope.non_managed_client_user) {
                    if (field == 'google_analytics' && !current_google_analytics_id) {
                        $scope.connectAccounts(
                            e,
                            'Integrations',
                            'google-analytics-modal.html'
                        );
                    } else if (field == 'search_console' && !current_site_url) {
                        $scope.connectAccounts(
                            e,
                            'Integrations',
                            'search-console-modal.html'
                        );
                    } else if (field == 'adword' && !$rootScope.adword_client_id) {
                        $scope.connectAccounts(
                            e,
                            'AdwordsClientController',
                            'themeX/integrations/_adwords_setup.html',
                            field
                        );
                    } else if (field == 'facebookads' && !current_facebook_ad_account_id) {
                        if ($scope.business.fb_access_token) {
                            $scope.connectAccounts(
                                e,
                                'FacebookAdsIntegration',
                                'themeX/integrations/_facebook_ads_scripts.html',
                                'facebookads'
                            );
                        } else {
                            $mdDialog.show({
                                templateUrl: 'themeX/integrations/_facebook_auth_script.html',
                                controller: [
                                    '$scope',
                                    '$mdDialog',
                                    function($scope, $mdDialog) {
                                        $scope.closeModal = function(e) {
                                            $mdDialog.cancel('cancel');
                                        };
                                    }
                                ]
                            });
                            e.preventDefault();
                            e.stopPropagation();
                        }
                    } else if (
                        field == 'callrail' &&
                        !current_callrail_client_id &&
                        !dummy_business
                    ) {
                        $scope.connectAccounts(
                            e,
                            'CallRailIntegrationController',
                            'themeX/integrations/_callrail_integration.html',
                            'callrail'
                        );
                    }
                } else {
                    e.preventDefault();
                    e.stopPropagation();
                }
            }
            if (e.currentTarget.classList.contains('side-menu-disable')) {
                e.preventDefault();
                e.stopPropagation();
            }
        };

        $scope.connectAccounts = function(e, controller, template, service) {
            $mdDialog
                .show({
                    scope: Utility.closeModal($scope, $mdDialog),
                    controller: controller,
                    templateUrl: template,
                    locals: {
                        business: $rootScope.business,
                        accounts: $scope.accounts,
                        service: service
                    }
                })
                .then(function() {})
                .finally(function() {
                    $rootScope.set_business($rootScope.business.id);
                });
            e.preventDefault();
            e.stopPropagation();
        };
    }
]);

clickxApp.controller('SelectBusiness', [
    '$scope',
    '$rootScope',
    '$resource',
    '$location',
    'Users',
    '$cookieStore',
    '$mdDialog',
    'Business',
    'User',
    function(
        $scope,
        $rootScope,
        $resource,
        $location,
        Users,
        $cookieStore,
        $mdDialog,
        Business,
        User
    ) {
        $rootScope.current_role = current_role;
        $rootScope.current_user_id = current_id;
        $rootScope.app_name = app_name;
        if (
            $rootScope.current_role == 'company_admin' ||
            $rootScope.current_role == 'company_user'
        ) {
            if (
                $rootScope.current_user_businesses == undefined ||
                $rootScope.current_user_businesses == ''
            ) {
                Users.get_businesses({ user_id: $rootScope.current_user_id }, function(
                    response
                ) {
                    $rootScope.current_user_businesses = response;
                    $scope.current_user_businesses = response;
                    if (
                        _.size($rootScope.current_user_businesses) > 1 &&
                        !$cookieStore.get('current_business_id')
                    ) {
                        if ($('.modal-open .modal').hasClass('in') == false) {
                            $scope.select_campaign();
                        }
                    } else {
                        if (response.length == 0) {
                            $cookieStore.put('sign_out_reason', 'expired+company');
                            $scope.sign_out();
                        } else {
                            if ($cookieStore.get('current_business_id') != '') {
                                biz_id = $cookieStore.get('current_business_id');
                            } else {
                                biz_id = response[0].id;
                            }
                            Business.current_business_dashboard({}, function(resp) {
                                window.location.href = resp.data.url;
                            });
                        }
                    }
                });
            } else {
                $scope.current_user_businesses = $rootScope.current_user_businesses;
            }
        }

        $scope.select_campaign = function(e) {
            if (typeof e !== 'undefined') e.preventDefault();
            $scope.new_business_id = $cookieStore.get('current_business_id') || '';
            $mdDialog.show({
                templateUrl: 'changeBusiness',
                controller: 'SetBusiness',
                escapeToClose: false
            });
        };

        $scope.sign_out = function() {
            User.sign_out({}, function(response) {
                window.location = '/users/sign_in';
            });
            return;
        };
    }
]);
