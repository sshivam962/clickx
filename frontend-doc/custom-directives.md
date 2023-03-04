## Custom Directive, Filter

### clickxBreadcrumb

`clickx-breadcrumb` is used to show breadcrumb on each pages. To make the implementation clean it was decided to define it in the main layout and provide the breadcrumbs as a list.

For this we are adding breadcrumb hash on route provider.

themeX_routes/academy.js
```
  $routeProvider.when('/:business_id/beta-academy/', {
    templateUrl: 'themeX/academy/index.html',
    controller: 'AcademyIndexCtrl',
    title: 'Academy | Clickx',
    breadcrumb:{
      enabled: true,
      links:[
        {name:'Home', link:'/b/dashboard'},
        {name:'Course', link:'/#/{{business_id}}/beta-academy'}
      }
    }
  });
```
###### Options

- **enabled**: Boolean value, `True` to enable, default is `True`
- **links**: Array of links, default show home if not defined

##### Method 1
app/layout/bu_themeX.html.haml
```
 .page-content
    .breadcrumb-ctrl{"ng-controller":"BreadCrumbController"}
      %analytic-breadcrumb-new{links:"breadcrumbLinks"}
    %div{'ng-view':''}
    = yield
```
app/assets/javascripts/themeX_helpers/helper.js
```
clickxApp.controller('BreadcrumbController', [
  '$scope', '$rootScope',
  function ($scope, $rootScope) {
    $rootScope.$on('$routeChangeSuccess', function (event, newUrl, oldUrl) {
      if (angular.isDefined(newUrl)) {
        var breadcrumbs = newUrl.breadcrumb;
        if (angular.isDefined(breadcrumbs)) {
          if (angular.isUndefined(breadcrumbs.enabled)) {
            $rootScope.breadcrumbEnabled = true;
          } else {
            $rootScope.breadcrumbEnabled = breadcrumbs.enabled;
          }
          $rootScope.breadcrumbLinks = breadcrumbs.links;
        } else {
          $rootScope.breadcrumbEnabled = true;
        }
      }
    });
  }
]);
```

> Code can be simplify with underscore or angular merge
```
var breadcrumbs = {
  enabled: true,
  links = [{
    name: 'Home', link:'/b/dashboard'
  }]
}

then merge with newUrl.breadcrumb
```

##### Method 2
app/layout/bu_themeX.html.haml
```
 .page-content
      %analytic-breadcrumb-new{links:"breadcrumbLinks"}
    %div{'ng-view':''}
    = yield
```
app/assets/javascripts/angular/themeX_app.js
```
clickxApp.run([
  '$scope','$rootScope',
  function ($scope, $rootScope) {
    $rootScope.$on('$routeChangeSuccess', function(event,newURL, oldURL){
      if(angular.isDefined(newURL) && angular.isDefined(newURL.breadcrumbLinks)){
        if(_.isArray(newURL.breadcrumbLinks)){
          $rootScope.breadcrumbLinks = newURL.breadcrumbLinks;
        }
      }
    });
  }
]);
```

#### Method 3

Define `$rootScope.$on('$routeChangeSuccess',fn')` inside directive element


> Currently we are using `Method 1`
##### Usage

```
.clickx-breadcrumb-wrapper{"ng-controller":"BreadcrumbController"}
    %clickx-breadcrumb{links:"breadcrumbLinks",enabled:"breadcrumbEnabled"}
```

- **links** - Array of name and link
- **enabled** - Show/Hide breadcrumb
