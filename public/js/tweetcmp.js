$(function() {
  $.ajax("/js/twitter-data.json").done(function(data) {
    if (data.length) {
      $('.twitter.smbox .smcontainer').each(function(i) {
        populateTweet(this, data[i]);
      });
    }
  });
});
