function adb_warning() {
  var html = '<div class="adblock_container"><div class="adblock_div"><img src="adblock.svg" type="image/svg+xml"></img><div class="msg_block"><h2>Please disable Adblock </h2><p>Your website appears to be running adblock. You will need to disable it for our Google Ads reporting to work.</p><button class="set_cookie" type="submit">OK</button></div></div></div>'

  var div = document.createElement('div');
  div.innerHTML = html;
  document.body.appendChild(div);
}

function adBlockDetected() {
  adb_warning()
}

if(document.cookie.indexOf("adb_flash=true") == -1){
  if(typeof fuckAdBlock !== 'undefined' || typeof FuckAdBlock !== 'undefined') {
    adBlockDetected()
  }
}

$(document).on('click', '.set_cookie', function(){
  document.cookie = "adb_flash=true"
  $(this).parent().parent().parent().parent().remove();
  return false;
})
