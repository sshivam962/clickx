## Angular Frontend Documentation 

Angular is a frontend framework use to build scalable web application. Angular 1.XX used
on this application with rails gems

### Dependencies 

Non angular dependencies 

> 
jQuery,jQuery UI, Bootstrap, Moment JS, Underscore JS, Masonary, Redactor,
HighChartJS, HighMapJS, Date range picker, Stripe JS, Cloudinary JS,
jQuery Slimscroll, jQuery rater, toastr, etc...

Angular dependencies  

> 
Angular ngRoute, Angular Sanitize, Angular Resource, Smart Table, ngClipboard,
ngFile Upload, etc...


### Angular Unit Testing 

Karma and Jasmine used for unit testing. All dependencies installed using 
`bower` and `npm`. You need to install [Node JS](https://nodejs.org) first, use version
above `6.9.1`. 

- Install `karma-cli` globally 
- Install `nodemon` globally
- Install `karma-ng-html2js-preprocessor` globally 
- Install `jasmin-core` globally 
- Run `npm install` and `bower install`

Run `karma start karma-config.js` and see results.

### Angular E2E Testing 

Protractor use for E2E Testing. 

- Install `protractor` globally
- Run `webdriver-manager update`
- Run `webdriver-manager start`

Run `protractor protractor.config.js` to run E2E testing.


#### Reference 

- Karma  [documentation](https://karma-runner.github.io/1.0/index.html)
- Jasmine [documentation](https://jasmine.github.io/)
- Protractor [documentation](http://www.protractortest.org/#/)
- Angular seed [demo](https://github.com/angular/angular-seed)
- Angular testing [tutorial](https://scotch.io/tutorials/testing-angularjs-with-jasmine-and-karma-part-1)


### PDFMake JS to create PDF 

**PDFMake** use to create PDF from canvas (with html2canvas), Dara URL, Table, Text.
We use PDFMake to create PDF for Table, Graphs etc.. This document will help
you create font icons, image icons, table 

#### Font Awesome icons 

We add 4-8 font-awesome icons to `vfs_fonts.js` (Currently not used), Please
follow this [instruction](https://github.com/bpampuch/pdfmake/wiki/Custom-Fonts---client-side) to add fonts to **PDFMake**.
Latest update, we use images to show icon, so we can apply `margin` & `padding` properties.

- Default settings can be found in `app/assets/javascripts/angular/config-pdfmake.js`.
- Font configuration can be found in `app/assets/javascripts/angular/themeX_app.js`, angular config block 
- Keyword table, user can hide any columns, these columns won't available on pdf file also 
- PDF will have all rows depend upon number rows shown on html page 
- Fontawesome not used in latest update, but fonts has more clarity than images, we use images
to apply some margin properties 


#### Material Icons and ASCII Codes

Complete [Material Icons](https://material.io/icons/) document.

| Icon Name             |  ASCII Code| 
| :---                  | :---       |
| keyboard_arrow_down   | \e313      |
| keyboard_arrow_left   | \e314      | 
| keyboard_arrow_right  | \e315      |
| keyboard_arrow_up     | \e316      |
| visibility            | \e8fa      |
| visibility_off        | \e8f5      |
| watch_later           | \e924      |
| phone                 | \e0cd      |
| add                   | \e145      |
| backspace             | \e14a      |
| create                | \e150      |
| send                  | \e163      |
| remove                | \e15b      |
| reply                 | \e15e      |
| access_alarm          | \e190      |
| access_alarms         | \e191      |
| access_time           | \e192      |
| add_alarm             | \e193      |
| camera_alt            | \e3b0      |
| add_a_photo           | \e439      |
| edit                  | \e3c9      |
| navigate_before       | \e408      |
| navigate_next         | \e409      |
| local_see             | \e557      |
| map                   | \e55b      |
| navigation            | \e55d      |
| near_me               | \e569      |
| place                 | \e55f      |
