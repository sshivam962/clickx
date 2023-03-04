
$(document).ready(function(){/* off-canvas sidebar toggle */

  $('[data-toggle=offcanvas]').click(function() {
    $(this).toggleClass('visible-xs text-center');
    $('.row-offcanvas').toggleClass('active');
    $('#lg-menu').toggleClass('hidden-sm').toggleClass('visible-sm');
    $('#xs-menu').toggleClass('visible-sm').toggleClass('hidden-sm');
    $('#lg-menu').toggleClass('hidden-xs').toggleClass('visible-xs');
    $('#xs-menu').toggleClass('visible-xs').toggleClass('hidden-xs');
    $('#btnShow').toggle();
  });
    $('a.disabled').click(function() { return false; });


  var sideBarElement  = $(this).find('#sidebar');
  /**
   * When user click on body, hide sidebar
   */
    $('body').on('click', function(e){

      if(sideBarElement.hasClass('openedSidebar')){

        sideBarElement.find('ul#xs-menu').show();
        sideBarElement.find('ul#lg-menu').hide();

        sideBarElement.removeClass('openedSidebar').css({
          width: "6%"
        });
      }

    });

  /** When use mouse in / mouse out **/
  $("#sidebar").mouseenter(function(){
    $(this).find('ul#xs-menu').hide();
    $(this).find('ul#lg-menu').show();
  })
  $('#sidebar').mouseleave(function(){
    $(this).find('ul#xs-menu').show();
    $(this).find('ul#lg-menu').hide()
  })

  /**
   * When user click on links inside sidebar, close sidebar, no toggle
   */
  winWIdth = $(window).width();
  if(winWIdth > 991) {
    $('#sidebar > ul > li').on('click','a', function(e){
      if($(this).children('img').length == 0){
        sideBarElement.find('ul#xs-menu').show();
        sideBarElement.find('ul#lg-menu').hide();
      }else{
        sideBarElement.find('ul#xs-menu').hide();
        sideBarElement.find('ul#lg-menu').show();
      }
      e.stopPropagation()
    })
  };
});


function word_count(){
    text_value=CKEDITOR.instances.editor1.getData();
    // make sure to change <b>text_editor_name</b> to the name of your text box!
    var matches = text_value.replace(/<[^<|>]+?>| /gi,' ').match(/\b/g);
    // Nicked the regular expression from an fckeditor example I saw somewhere..
    var count = 0;
    if(matches) {
        count = matches.length/2;
    }
    document.getElementById("word_count").innerHTML=count;
}
