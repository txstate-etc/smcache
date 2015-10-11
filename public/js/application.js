var tweets = [];
var instas = [];

function updateInstas() {
  if (instas.length == 0) {
    return;
  }

  // TODO: rotate
  var t = instas[0];
  $('#instagram .smcontainer').html(
    '<img src="' + t.url + '">'
  );
}

function updateTweets() {
  if (tweets.length == 0) {
    return;
  }

  // TODO: rotate
  var t = tweets[0];
  $('#twitter .smcontainer').html(
    '<div class="tweet-header">' +
      '<a href="//twitter.com/' + t.screen_name + '">' +
        '<img src="'+ t.profile_image +'"/>' +
        '<span class="display-name">' + t.display_name + '</span>' +
        '<span class="screen-name">@' + t.screen_name + '</span>' +
      '</a>' +
    '</div>' +
    '<div class="tweet-body">' +
      '<p>' + linkifyTweet(t.text) + '</p>' +
    '</div>' +
    '<div class="tweet-footer">' +
      '<a href="//twitter.com/'+ t.screen_name +'/status/'+ t.tweetid +'">' + 
        fmtTweetTime(t.tweettime) + 
      '</a>' +
    '</div>' 
  );
}

function fmtTweetTime(time) {
  t = moment(time);
  if (t.isBefore(moment().subtract(7, 'days'))) {
    return t.format('h:mm A - D MMM YYYY')
  } else {
    return t.fromNow();
  }
}

function linkifyTweet(text) {
  // final Pattern linkPattern = Pattern.compile("(https?://\\S+)", Pattern.CASE_INSENSITIVE);
  // final Pattern userPattern = Pattern.compile("(^|)@(\\w+)");
  // final Pattern hashtagPattern = Pattern.compile("(^|)#(\\w+)");
  // 
  // text = linkPattern.matcher(text).replaceAll("<a href=\"$1\">$1</a>");
  // text = userPattern.matcher(text).replaceAll("<a href=\"https://twitter.com/$2\">$0</a>");
  // text = hashtagPattern.matcher(text).replaceAll("<a href=\"https://twitter.com/search?q=%23$2\">$0</a>");
  
  // linkify urls
  text = text.replace(/(https?:\/\/\S+)/gi, '<a href="$1">$1</a>');  
  
  // linkify @screen_names
  text = text.replace(/(^|)@(\w+)/gi, '<a href="https://twitter.com/$2">$0</a>');  
  
  // linkify #hashtags
  text = text.replace(/(^|)#(\w+)/gi, '<a href="https://twitter.com/search?q=%23$2">$0</a>');  

  return text;
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
