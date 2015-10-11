var tweets = [];
var instas = [];

function updateInstas() {
  if (instas.length == 0) {
    return;
  }

  // TODO: rotate
  $('.instagram .smcontainer').html(fmtOneInsta(instas[0]));
}

function updateTweets() {
  if (tweets.length == 0) {
    return;
  }

  // TODO: rotate
  $('.twitter .smcontainer').html(fmtOneTweet(tweets[0]));
}

$(function() {
  
  $.ajax("/twitter").done(function(data) {
    tweets = data;
    updateTweets();
  });

  $.ajax("/instagram").done(function(data) {
    instas = data;
    updateInstas();
  });

});
