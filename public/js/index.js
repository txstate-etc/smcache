var tweets = [];
var instas = [];

var slick_opts = {
  speed: 500,
  fade: true,
  cssEase: 'linear',
  // autoplay: true,
  autoplaySpeed: 4000,
  // adaptiveHeight: true,
};

function updateInstas() {
  if (instas.length == 0) {
    return;
  }

  var $container = $('.instagram .smcontainer');

  $container.empty();

  instas.forEach(function(item){
    populateInsta($container, item);
  });

  $container.slick(slick_opts);
}

function updateTweets() {
  if (tweets.length == 0) {
    return;
  }

  var $container = $('.twitter .smcontainer');

  $container.empty();

  tweets.forEach(function(item){
    populateTweet($container, item);
  });

  $container.slick(slick_opts);
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
