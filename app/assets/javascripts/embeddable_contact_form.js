  respondToParentMessage = function(e) {
    switch (e.data.action) {
      case 'sizing?':
        respondToSizingMessage(e)
        break;
      case 'visit_details':
        respondToVisitDetails(e)
        break;

      default:
        break;
    }
  }
  respondToSizingMessage = function(e) {
    payload = {
      action: 'sizing',
      size: document.body.scrollHeight + ',' + document.body.scrollWidth
    }
    e.source.postMessage(payload, e.origin);
  }

  respondToVisitDetails = function(e) {
    $('[name=visit_id]').val(e.data.visitId)
    $('[name=visitor_id]').val(e.data.visitorId)
  }

  var $activeForm = $('form').eq(0);
  var self = this;
  $activeForm.on('submit', function(e) {
    if (parent.postMessage) {
      $(this).find(':submit').attr('disabled','disabled');
      parent.postMessage('formSubmitted', '*');
    }
  });
  // we have to listen for 'message' from parent frame 
  window.addEventListener('message', respondToParentMessage, false);
