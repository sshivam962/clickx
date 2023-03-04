clickxApp.filter('humanize', function() {
  return function(text) {
    if (text) {
      text = text.split('_');
      for (var i in text) {
        var word = text[i];
        word = word.toLowerCase();
        word = word.charAt(0).toUpperCase() + word.slice(1);
        text[i] = word;
      }
      return text.join(' ');
    }
  };
});
