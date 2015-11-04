var tweets = [];
var instas = [];
var fbooks = [];

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

  // instas.forEach(function(item){
  //   populateInsta($container, item);
  // });
  
  populateInsta($container, instas[0]);

  // $container.slick(slick_opts);
}

function updateFbooks() {
  if (fbooks.length == 0) {
    return;
  }

  var $container = $('.facebook .smcontainer');

  $container.empty();

  // fbooks.forEach(function(item){
  //   populateFbook($container, item);
  // });

  populateFbook($container, fbooks[0]);

  // $container.slick(slick_opts);
}

function updateTweets() {
  if (tweets.length == 0) {
    return;
  }

  var $container = $('.twitter .smcontainer');

  $container.empty();

  // tweets.forEach(function(item){
  //   populateTweet($container, item);
  // });

  populateTweet($container, tweets[0]);

  // $container.slick(slick_opts);
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

  $.ajax("/facebook").done(function(data) {
    fbooks = data;
    updateFbooks();
  });
});
