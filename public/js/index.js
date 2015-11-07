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

function loadMain() {
  $('.page-header h1').text('Recent Social Media Posts');
  $('.page-header p').text('Rotate through the 3 latest instagram, twitter, and facebook posts from @txst.');
  $('#content').html(maintmpl());

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
}

function loadInstagram() {
  $('.page-header h1').text('Instagram Comparison');
  $('.page-header p').text('Official embed code on left, our code on right.');
  $('#content').html(igmaintmpl());
  $.ajax("/js/instagram-data.json").done(function(data) {
    if (data.length) {
      $('.instagram.smbox .smcontainer').each(function(i) {
        populateInsta(this, data[i]);
      });
    }
  });
  instgrm.Embeds.process();
}

function loadTwitter() {
  $('.page-header h1').text('Twitter Comparison');
  $('.page-header p').text('Official embed code on left, our code on right.');
  $('#content').html(twmaintmpl());
  $.ajax("/js/twitter-data.json").done(function(data) {
    if (data.length) {
      $('.twitter.smbox .smcontainer').each(function(i) {
        populateTweet(this, data[i]);
      });
    }
  });
  twttr.widgets.load();
}

function loadFacebook() {
  $('.page-header h1').text('Facebook Comparison');
  $('.page-header p').text('Official embed code on left, our code on right.');
  $('#content').html(fbmaintmpl());
  $.ajax("/js/facebook-data.json").done(function(data) {
    if (data.length) {
      $('.facebook.smbox .smcontainer').each(function(i) {
        populateFbook(this, data[i]);
      });
    }
  });
  FB.XFBML.parse();
}

$(function() {
  $('#navbar a').on('click', function() {
    $('#navbar li.active').removeClass('active');
    $(this).closest('li').addClass('active');

    destroyVideos();

    var text = $(this).text();
    if (/live/i.test(text)) {
      loadMain();
    } else if (/instagram/i.test(text)) {
      loadInstagram();
    } else if (/twitter/i.test(text)) {
      loadTwitter();
    } else if (/facebook/i.test(text)) {
      loadFacebook();
    }
  });

  // loadFacebook();
  loadMain();
});
