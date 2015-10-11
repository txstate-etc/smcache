$(function() {
  $.ajax("/js/instagram-data.json").done(function(data) {
    if (data.length) {
      $('.instagram.smbox .smcontainer').each(function(i) {
        populateInsta(this, data[i]);
      });
    }
  });
});
