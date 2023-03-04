angular.module('clickxApp.Contents', []).config([
    '$routeProvider',
    '$locationProvider',
    function($routeProvider, $locationProvider) {
        $routeProvider.when('/contents', {
            templateUrl: 'themeX/contents/index.html',
            controller: 'ContentsIndex',
            title: 'Content Lists | __app_name__',
            breadcrumb: {
                links: [
                    { name: 'Home', link: '/b/dashboard' },
                    { name: 'Content', link: '/#/contents' }
                ]
            }
        });
        $routeProvider.when('/content/view_orders', {
            templateUrl: 'themeX/contents/view_orders.html',
            controller: 'ContentOrderView',
            title: 'Content Order View | __app_name__',
            breadcrumb: {
                links: [
                    { name: 'Home', link: '/b/dashboard' },
                    { name: 'Content', link: '/#/contents' },
                    { name: 'Clickx Orders', link: '/#/content/view_orders' }
                ]
            }
        });
        $routeProvider.when('/content_order/new', {
            templateUrl: 'themeX/contents/writers_form.html',
            controller: 'contentWritersAccess',
            title: 'New Content Access',
            breadcrumb: {
                links: [
                    { name: 'Home', link: '/b/dashboard' },
                    { name: 'Content', link: '/#/contents' },
                    { name: 'Content Order', link: '/#/content_order/new' }
                ]
            }
        });
        $routeProvider.when('/content_order/:id/edit', {
            templateUrl: 'themeX/contents/writers_form.html',
            controller: 'contentWritersAccess',
            title: 'Edit Content Access | __app_name__',
            breadcrumb: {
                links: [
                    { name: 'Home', link: '/b/dashboard' },
                    { name: 'Content', link: '/#/contents' },
                    { name: 'Content Edit', link: '/#/content_order/{{id}}/edit' }
                ]
            }
        });
        $routeProvider.when('/:business_id/contents/new', {
            templateUrl: 'themeX/contents/view_content.html',
            controller: 'ContentView',
            title: 'New Content | __app_name__',
            breadcrumb: {
                links: [
                    { name: 'Home', link: '/b/dashboard' },
                    { name: 'Content', link: '/#/contents' },
                    { name: 'New Content', link: '/#/{{business_id}}/contents/new' }
                ]
            }
        });
        $routeProvider.when('/:business_id/contents/:id', {
            templateUrl: 'themeX/contents/view_content.html',
            controller: 'ContentView',
            title: 'View Content | __app_name__',
            breadcrumb: {
                links: [
                    { name: 'Home', link: '/b/dashboard' },
                    { name: 'Content', link: '/#/contents' },
                    { name: 'Edit Content', link: '/#/{{business_id}}/contents/{{id}}' }
                ]
            }
        });
    }
]);