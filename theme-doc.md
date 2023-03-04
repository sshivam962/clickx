## Theme Documentation 

Latest theme based on Google materialize design. We use `Bootstrap Material` along with angular 
support libraries. Here are list libraries used for this theme 

### How to Run Application 

- Clone application 
- Install **RVM**, **Postgres 9.4^**, **NodeJS**, **Redis Server**, **MemCache**
- Install Rubies using **RVM**, Install `Ruby 2.4.1` or above
- Install **CMake** and **memcache**
- Run `bundle install` inside directory
- Get `.env` file contents 
- Run `rake db:setup` or (`rake db:create`,`rake db:migrate`, `rake db:seed`)
- Run Server `rails s <p=PORT><b=BIND IP>`

> These are Frameworks and Plugins used in application. Some plugin can be upgrade and it won't break anything.
  Some plugin are not in active development. It will create security issues later. Remove plugins those are not active in
  last 2-3 Year.

  
 #### CSS Framework
 
 | Framework | Version | Upgrade | Description |
 | :--- | :---: | :---: | :----|
 | [Bootstrap](https://github.com/twbs/bootstrap-sass) | v3.3.6 | v3.3.7| Popular Responsive CSS Framework |
 | [Material](https://github.com/angular/material) | v1.1.0 | - | Google material design |
 | [Bootstrap Material Design](https://github.com/FezVrasta/bootstrap-material-design) | - | - | Boostrap material framework |
 | [Angular Materialize](https://github.com/angular/material) | v1.1.0 | - | Angular material css styles |
 
 ### Javascript Framework and Plugins 
 
 ##### Javascript, Vanila Js plugins
  
 | Plugin       | Version    | Upgrade     |
 | :--------    | :--------: | :---------: |
 | [jQuery](https://github.com/jquery/jquery) | v1.12.4| |
 | [jQuery UI](https://github.com/jquery/jquery-ui) | v1.12.1 | |
 | [Bootstrap](http://getbootstrap.com/) | v3.3.1 | v3.3.7 | 
 | [Dropzone](http://www.dropzonejs.com/) | - | -  |  
 | [Moment JS](https://momentjs.com/) | v2.10.3 | - |
 | [Ripple JS](https://github.com/FezVrasta/bootstrap-material-design/tree/master/dist/js) | v0.5.10 | - |
 | [Velocity](https://github.com/julianshapiro/velocity) | v1.2.2 | - |
 | [Typeahead](https://github.com/twitter/typeahead.js) | v0.10.1 | - | 
 | [Toastr](https://github.com/CodeSeven/toastr) | - | - |
 | [Daterange picker](https://github.com/dangrossman/bootstrap-daterangepicker) | v1.3.23 | - |
 | [Material JS](https://github.com/FezVrasta/bootstrap-material-design/blob/master/dist/js) | - | - |
 | [jQuery Minicolor](https://github.com/claviska/jquery-minicolors)| - | - |
 | [jQuery Dropdown](https://github.com/claviska/jquery-dropdown) | - | - | 
 | [Boostrap tabdrop](https://github.com/jmschabdach/bootstrap-tabdrop) | - | - |
 | [Bootstrap tokenfield](https://github.com/sliptree/bootstrap-tokenfield) | - | - | 
 | [jQuery rater](https://github.com/ReneMuetti/Raterater) | v1.1.1 | - | 
 | [jQuery nanoscroller](https://github.com/jamesflorentino/nanoScrollerJS) | v0.8.4 | - | 
 | [Enquire](https://github.com/WickyNilliams/enquire.js) | v2.1.2 | - |
 | [jQCloud](https://github.com/lucaong/jQCloud) | 2v.0.1| - |
 | [Clipboard](https://github.com/zenorocha/clipboard.js/) | v1.5.9 | |
 | [jQuery InputMask](https://github.com/RobinHerbots/jquery.inputmask) | v3.2.8 | - |
 | [Papa Parse](https://github.com/mholt/PapaParse) | v4.1.1 | - |
 | [Inflection](https://github.com/dreamerslab/node.inflection) | - | - |
 | [jQuery Cloudinary](https://github.com/cloudinary/cloudinary_js)| v1.0.23 | - |
 | [jQuery File Upload](https://github.com/blueimp/jQuery-File-Upload) | v5.42.3 | - |
 | [jQuery Iframe Transport](https://github.com/blueimp/jQuery-File-Upload) | v1.8.3 | - |
 | [jQuery Rate It](https://github.com/gjunge/rateit.js) | v1.0.24 | - |
 
 ##### Angular Plugins
  
 | Plugin | Version | Upgrade |
 | :----- | :---: | :---: |
 | [Angular JS](https://github.com/angular/angular.js) | v1.3.8 | - |  
 | [Angular Resource](https://github.com/angular/angular.js/tree/master/src/ngResource) | v1.3.8 | -|
 | [Angular Route](https://github.com/angular/angular.js/tree/master/src/ngRoute) | v1.3.8 | - |
 | [Angular Animate](https://github.com/angular/angular.js/tree/master/src/ngAnimate)| v1.3.8 | - |
 | [Angular Aria](https://github.com/angular/angular.js/tree/master/src/ngAria) | v1.3.8 | - |
 | [Angular Cookies](https://github.com/angular/angular.js/tree/master/src/ngCookies)| 1.3.8| - |
 | [Angular Message](https://github.com/angular/angular.js/tree/master/src/ngMessages) | v1.3.8 | - |
 | [Angular Material](https://github.com/angular/material) | v1.1.0 | - | 
 | [Angular date range picker](https://github.com/fragaria/angular-daterangepicker) | - | - | 
 | [Angular Minicolor](https://github.com/kaihenzler/angular-minicolors) | - | - |  
 | [Angular moment](https://github.com/urish/angular-moment) | - | - |
 | [Angular Tooltip](https://github.com/720kb/angular-tooltips) | v1.1.8 | - |
 | [Angular Wizard](https://github.com/mgonto/angular-wizard) | v0.4.2 | - | 
 | [Angular Omni bar](https://github.com/isteven/angular-omni-bar) | v1.0.1| - | 
 | [Angular XEditable](https://github.com/vitalets/angular-xeditable) | v0.2.0 | - |
 | [Angular Audio](https://github.com/danielstern/ngAudio) | - | - |
 | [Angular Cloudinary](https://github.com/cloudinary/cloudinary_angular)| - | - |
 | [Angular Fileupload](https://github.com/nervgh/angular-file-upload)| v3.2.5 | - |
 | [Angular Gravatar](https://github.com/wallin/angular-gravatar)| - | - |
 | [Angular MD5](https://github.com/gdi2290/angular-md5) | v0.1.8| - |
 | [Angular Payment](https://github.com/laurihy/angular-payments) | - | - |
 | [Angular Redactor](https://github.com/TylerGarlick/angular-redactor)| - | - |
 | [Angular Tek Progress bar](https://github.com/TekVanDo/Angular-Tek-Progress-bar) | v0.2.0 | - |
 | [Angular Smart Table](https://github.com/lorenzofox3/Smart-Table) | v2.0.2| - |
 | [Angular Loadingbar](https://github.com/chieffancypants/angular-loading-bar) | v0.8.0 | - |
 | [Angular jQCloud](https://github.com/mistic100/angular-jqcloud)| v1.0.2| - | 
 | [Angular Slimscroll](https://github.com/ziscloud/angular-slimscroll) | - | - |
 | [Angular Switch](https://github.com/xpepermint/angular-ui-switch) | - | - |
 | [NG CSV](https://github.com/asafdav/ng-csv)| - | - |
 | [NG Infinite Scroll](https://github.com/sroze/ngInfiniteScroll) | - | - | 
 | [NG Sortable](https://github.com/a5hik/ng-sortable) | - | - |
 | [NG Autocomplete](https://github.com/wpalahnuk/ngAutocomplete)| - | - |
 | [NG Clipboard](https://github.com/sachinchoolur/ngclipboard)| v1.1.1 | - |
 | [NG Inflection](https://github.com/konsumer/ngInflection)| - | - |
 | [NG Storage](https://github.com/gsklee/ngStorage)| v0.3.4 | - |
 | [Ng dropzone](https://github.com/thatisuday/ng-dropzone) | - | - |
 | [UI Select](http://github.com/angular-ui/ui-select) | v0.12.1| - |
 | [MD Date range picker](https://github.com/greatCodeIdeas/md-date-range-picker) | v9.4.2 | - |
 
 
 
 ##### File Upload 
 | Plugin | Version | Upgrade | Description |
 |:----| :---:| :----:| :---- |
 | [Dropzone](http://www.dropzonejs.com/) | - | - | Drag and Drop file upload| 
 | [Ng dropzone](https://github.com/thatisuday/ng-dropzone) | - | - | Angular support for Dropzone |
 | [Cloudinary](http://cloudinary.com/) Cloud service and API | - | - | Image/Video cloud server |
 
 ##### Chart, Map
 | Plugin | Version | Upgrade | Description |
 |:----| :---:| :----:| :--- |
 | [Highchart](https://www.highcharts.com/) | v4.1.5| - |  Graph, Piechart plugin |
 | [Highchart More](https://www.highcharts.com/) | v4.1.9 | - | Extra Highchart addons |
 | [Highmap](https://www.highcharts.com/) | v5.0.6 | - | Map plugin from HIghchart |
 | [Highmap World](https://www.highcharts.com/) | - | - | - |
 | [Highchart Wordld Map]() | - | - | - |
 | [Highmap Plugin](https://www.highcharts.com/) | v1.1.8 | - | - | 
  
 ##### Date and Time
 
 | Plugin | Version | Upgrade | Description |
 | :---- | :---: | :---: | :---- |
 | [md date range picker](https://github.com/greatCodeIdeas/md-date-range-picker) | - | - | Daterange picker for angular material |
 | [moment js](https://momentjs.com/) | - | - | Time and Date utility plugin |
 
 ##### Notifications 
 
 | Plugin | Version | Upgrade | Description |
 | :--- | :----: | :---: | :----|
 | [Toastr](https://github.com/CodeSeven/toastr) | - | - | Notification plugin |
 
 ##### Utilities and Helpers
 
 | Plugin | Version | Upgrade | Description |
 | :--- | :---: | :----: | :---- |
 | [Underscore JS](http://underscorejs.org/) | - | - | Helper functions |
 
 ##### Table and Tabular 
 
 | Plugin | Version | Upgrade | Description |
 | :--- | :---: | :---: | :----|
 | [Smart Table](http://lorenzofox3.github.io/smart-table-website/) | - | - | Angular table with many features |
 
 ##### PDF Creation 
 
 | Plugin | Version | Upgrade | Description |
 | :---   | :---:   | :---:   | :----       |
 | [PDFMake](https://github.com/bpampuch/pdfmake) | |  - | Create PDF from Data URL, Text and Tables |
 
 #### Icons 
 
 | Icon set | Description |
 | :---- | :---- |
 | [Material Icons](https://material.io/icons/) | Material icon set from google|
 | [Font Awesome](http://fontawesome.io/icons/) | Popular font awesome icon set |
 | [Clickx Icons](https://clickx.io) | Custom clickx icon set | 
 
 ##### Color 
  
    Color are used as Primary, Secondary as per Bootstrap Style 
  
  - <b style="color: #f5f5f5">White Color ( Default )</b>  `#fff` 
  - <b style="color:#60BBEA">Accent Blue Color ( Primary ) </b>    `#60BBEA`
  - <b style="color:#d19921">Merigold Color ( Warning ) </b>  `#d19921`
  - <b style="color:#8bc34a">Accent Green Color ( Success )</b>   `#60BBEA`
  - <b style="color: #EF5023">Accent Red Color</b> `#EF5023`
  - <b style="color: #4C4E60">Darkstone Blue Color</b> `#4C4E60`
  - <b style="color: #F6F6F7">Light Haze Color</b>  `#F6F6F7`
  - <b style="color: #777777">Grey Color</b>`#777777`
  - <b style="color: #f16b45">Orange Color ( Warning ) </b> `#f16b45`
  - <b style="color: #F44336">Red Color ( Danger ) </b>    `#F44336`
  
  
 ##### Frontend tests  documentation 
 
 [Read documentation](frontend-doc.md)
 
  