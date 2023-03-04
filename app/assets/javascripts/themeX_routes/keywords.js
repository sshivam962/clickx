angular.module('clickxApp.Keywords', []).config([
  '$routeProvider',
  '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.when('/:business_id/keyword_history/:keyword', {
      templateUrl: 'themeX/keywords/keyword_history.html',
      controller: 'SeoRankHistory',
      title: 'SEO Rank History | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Keyword', link: '/#/rankings' },
          {
            name: 'Keyword Rank History',
            link: '/#/{{business_id}}/keyword_history/{{keyword}}'
          }
        ]
      }
    });
    $routeProvider.when('/rankings', {
      templateUrl: 'themeX/keywords/seo_keywords.html',
      controller: 'viewKeywords',
      title: 'View Keywords | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Keywords', link: '/#/rankings' }
        ]
      }
    });
    $routeProvider.when('/keyword_opportunities', {
      templateUrl: 'themeX/keywords/potential_keywords.html',
      controller: 'potentialKeywordsCtrl',
      title: 'Keyword Opportunities | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Keywords', link: '/#/rankings' },
          { name: 'Keyword Opportunities', link: '/#/keyword_opportunities' }
        ]
      }
    });
    $routeProvider.when('/tags', {
      templateUrl: 'themeX/keywords/tags_folder.html',
      controller: 'tagFolder',
      title: ' Tag Folder | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Keywords', link: '/#/rankings' },
          { name: 'Tags', link: '/#/tags' }
        ]
      }
    });
    $routeProvider.when('/:business_id/keywords/tag/:tag_id', {
      templateUrl: 'themeX/keywords/tag_keywords.html',
      controller: 'tagKeywords',
      title: 'Tag Keywords | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Keywords', link: '/#/rankings' },
          { name: 'Tag Keywords', link: '/#/{{business_id}}/tag_keywords' }
        ]
      }
    });
    $routeProvider.when('/keyword_trash', {
      templateUrl: 'themeX/keywords/keyword_trash.html',
      controller: 'KeywordTrash',
      title: 'Keyword Trash | __app_name__',
      breadcrumb: {
        links: [
          { name: 'Home', link: '/b/dashboard' },
          { name: 'Keywords', link: '/#/rankings' },
          { name: 'Keywords Trash', link: '/#/keyword_trash' }
        ]
      }
    });
  }
]);
