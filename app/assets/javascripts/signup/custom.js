

$(function() {

	$.wijets.make(); 	// Make yo Widjit - see docs for more details.
	prettyPrint(); 		//Apply Code Prettifier

    $('.refresh-panel').click(function () {
        var panel = $(this).closest('.panel');
        panel.append('<div class="panel-loading"><div class="panel-loader-circular"></div></div>');
        setTimeout(function () {
            panel.find('.panel-loading').remove();
        }, 1500)
    });

	// Bootstrap JS
    $('.popovers').popover({container: 'body', trigger: 'hover', placement: 'top'}); //bootstrap's popover
    $('.tooltips, [data-toggle="tooltip"]').tooltip(); //bootstrap's tooltip

    $('.select').dropdown(); // DropdownJS

    //Tabdrop
    jQuery.expr[':'].noparents = function(a,i,m){
            return jQuery(a).parents(m[3]).length < 1;
    }; // Only apply .tabdrop() whose parents are not (.tab-right or tab-left)
    $('.nav-tabs').filter(':noparents(.tab-right, .tab-left)').tabdrop();

	//Background Pattern
	$(".demo-blocks").click(function(){
		$('.layout-boxed').css('background',$(this).css('background'));
		return false;
	});
});




// Campaign Intelligence

  $(document).ready(function() {

    //Load Wizards
    $('#basicwizard').stepy();
    $('#wizard').stepy({finishButton: true, titleClick: true, block: true, validate: true});

    //Add Wizard Compability - see docs
    $('.stepy-navigator').wrapInner('<div class="pull-right"></div>');

    //Make Validation Compability - see docs
    $('#wizard').validate({
        errorClass: "help-block",
        validClass: "help-block",
        highlight: function(element, errorClass,validClass) {
           $(element).closest('.form-group').addClass("has-error");
        },
        unhighlight: function(element, errorClass,validClass) {
            $(element).closest('.form-group').removeClass("has-error");
        }
     });

});



// Date Range Picker


$(document).ready(function() {
        // Date Range Picker




        $('#daterangepicker2').daterangepicker({
        ranges: {
            'Today': [moment(), moment()],
            'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
            'Last 7 Days': [moment().subtract('days', 6), moment()],
            'Last 30 Days': [moment().subtract('days', 29), moment()],
            'This Month': [moment().startOf('month'), moment().endOf('month')],
            'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
        },
        opens: 'left',
        startDate: moment().subtract('days', 29),
        endDate: moment()
        },
        function(start, end) {
            $('#daterangepicker2 span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
        });


        //Eternicode Datepicker
        $("#datepicker").datepicker({todayHighlight: true});
        $('#datepicker-pastdisabled').datepicker({
            todayHighlight: true,
            startDate: "-3d",
            endDate: "+3d"
        });
        $('#datepicker-startview').datepicker({
            todayHighlight: true,
            startView: 1
        });
        $('#datepicker-inline').datepicker({todayHighlight: true});
        $('#datepicker-range').datepicker({todayHighlight: true});



        // $('.input-group-addon .fa-th').removeClass('fa fa-th').addClass('ti ti-view-grid');
        // $('.input-group-addon .fa-close').removeClass('fa fa-close').addClass('ti ti-close');
        // $('.input-group-addon .fa-clock-o').removeClass('fa fa-clock-o').addClass('ti ti-time');
        // $('.input-group-addon .fa-calendar').removeClass('fa fa-calendar').addClass('ti ti-calendar');

});




jQuery(document).ready(function() {


// Extrabar
    $("#layout-static .static-content-wrapper").append("<div class='extrabar-underlay'></div>");

// Calendar

    $('#calendar').datepicker({todayHighlight: true});




});




$(document).ready(function() {

    //Load Wizards
    $('#basicwizard').stepy();
    $('#wizard').stepy({finishButton: true, titleClick: true, block: true, validate: true});

    //Add Wizard Compability - see docs
    $('.stepy-navigator').wrapInner('<div class="pull-right"></div>');

    //Make Validation Compability - see docs
    $('#wizard').validate({
        errorClass: "help-block",
        validClass: "help-block",
        highlight: function(element, errorClass,validClass) {
           $(element).closest('.form-group').addClass("has-error");
        },
        unhighlight: function(element, errorClass,validClass) {
            $(element).closest('.form-group').removeClass("has-error");
        }
     });

});




// Location add business hours

$('#locabusinessbours').click(function(){
    this.checked?$('#locabusicon').show(500):$('#locabusicon').hide(500);
});

// Time Picker for Location - you can remove if you don't need
$('#mons').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#mone').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#tues').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#tuee').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#weds').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#wede').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#thus').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#thue').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#fris').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#frie').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#sats').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#sate').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});
$('#suns').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});

$('#sune').timepicker({
	template: false,
	showInputs: false,
	minuteStep: 5
});


	//Tokenfield

	var engine = new Bloodhound({
		local: [{value: 'web'}, {value: 'mobile'}, {value: 'social media'} , {value: 'video marketing'}, {value: 'seo'}, {value: 'blogs'}, {value: 'visa'}, {value: 'Master'}, {value: 'Cash'}, {value: 'Check'}, {value: 'Credit Card'},{value: 'Debit Card'},{value: 'american express'}],
		datumTokenizer: function(d) {
			return Bloodhound.tokenizers.whitespace(d.value);
		},
		queryTokenizer: Bloodhound.tokenizers.whitespace
	});

	engine.initialize();


	$('#categories-typeahead').tokenfield({
		typeahead: [null, { source: engine.ttAdapter() }]
	});

	$('#payment-typeahead').tokenfield({
		typeahead: [null, { source: engine.ttAdapter() }]
	});

  $('#keyword-typeahead').tokenfield({
    typeahead: [null, { source: engine.ttAdapter() }]
  });




	// test


	    Dropzone.options.myAwesomeDropzone = {
      paramName: "file",
      maxFilesize: 10,
      url: 'UploadImages',
      previewsContainer: "#dropzone-previews",
      uploadMultiple: true,
      parallelUploads: 5,
      maxFiles: 20,
      init: function() {
        var cd;
        this.on("success", function(file, response) {
          $('.dz-progress').hide();
          $('.dz-size').hide();
          $('.dz-error-mark').hide();
          console.log(response);
          console.log(file);
          cd = response;
        });
        this.on("addedfile", function(file) {
          var removeButton = Dropzone.createElement("<a href=\"#\">Remove file</a>");
          var _this = this;
          removeButton.addEventListener("click", function(e) {
            e.preventDefault();
            e.stopPropagation();
            _this.removeFile(file);
            var name = "largeFileName=" + cd.pi.largePicPath + "&smallFileName=" + cd.pi.smallPicPath;
            $.ajax({
              type: 'POST',
              url: 'DeleteImage',
              data: name,
              dataType: 'json'
            });
          });
          file.previewElement.appendChild(removeButton);
        });
      }
    };

