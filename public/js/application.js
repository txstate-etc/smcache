function populateInsta(el, item) {
  $(el).append(fmtOneInsta(item));
  if (item.video_url) {
    videojs("video-"+item.postid);
  }
}

function fmtOneInsta(item) {
  return '' +
    '<div class="insta-wrap">' +
      '<div class="ig-header">' +
        '<a href="//instagram.com/' + 'txst' + '">' +
          '<img src="'+ '//scontent-dfw1-1.cdninstagram.com/hphotos-xpf1/t51.2885-19/10644095_326569534186928_472316609_a.jpg' +'"/>' +
          '<span class="screen-name">' + 'txst' + '</span>' +
        '</a>' +
        '<span class="posttime">' + fmtInstaTime(item.posttime) + '</span>' +
      '</div>' +
      '<div class="ig-body">' +
        fmtInstaVideo(item) +
        fmtInstaImage(item) +
      '</div>' +
      '<div class="ig-footer">' +
        '<p>' + linkifyInsta(item.caption) + '</p>' +
      '</div>' +
    '</div>'
  ;
}

function fmtInstaImage(item) {
  if (item.video_url) {
    return '';
  }

  return '<img src="' + item.url + '">';
}

function fmtInstaVideo(item) {
  if (!item.video_url) {
    return '';
  }

  return '' +
    '<div class="insta-video-wrap">' +
      '<video id="video-'+ item.postid +'" class="video-js vjs-default-skin ' +
        'vjs-fluid vjs-big-play-centered" controls preload="auto" ' +
        'poster="'+ item.url +'">' +
        '<source src="'+ item.video_url +'" type="video/mp4" />' +
        '<p class="vjs-no-js">' +
          'To view this video please enable JavaScript, and consider upgrading to a web browser that ' +
          '<a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>' +
        '</p>' +
      '</video>' +
    '</div>'
  ;
}

function fmtInstaTime(time) {
  return moment(time).fromNow(true);
}

function linkifyInsta(text) {
  if (!text) {
    return '';
  }

  // linkify urls
  text = text.replace(/(https?:\/\/\S+)/gi, '<a href="$1">$1</a>');  
  
  // linkify @screen_names
  text = text.replace(/(^|)@(\w+)/gi, '<a href="//instagram.com/$2/">$&</a>');  
  
  // linkify #hashtags
  text = text.replace(/(^|)#(\w+)/gi, '<a href="//instagram.com/explore/tags/$2/">$&</a>');  

  return text;
}

function populateTweet(el, item) {
  $(el).append(fmtOneTweet(item));
  if (item.video_url) {
    videojs("video-"+item.tweetid);
  }
}

function fmtOneTweet(item) {
  return '' +
    '<div class="tweet-container">' +
      fmtTweetVideo(item) +
      fmtTweetImage(item) +
      '<div class="tweet-wrap">' +
        '<div class="tweet-header">' +
          '<a href="//twitter.com/' + item.screen_name + '">' +
            '<img src="'+ item.profile_image +'"/>' +
            '<span class="display-name">' + item.display_name + '</span>' +
            '<span class="screen-name">@' + item.screen_name + '</span>' +
          '</a>' +
        '</div>' +
        '<div class="tweet-body">' +
          '<p>' + linkifyTweet(item.text) + '</p>' +
        '</div>' +
        '<div class="tweet-footer">' +
          '<a href="//twitter.com/'+ item.screen_name +'/status/'+ item.tweetid +'">' + 
            fmtTweetTime(item.tweettime) + 
          '</a>' +
        '</div>' +
      '</div>' +
    '</div>' 
  ;
}

function fmtTweetImage(item) {
  if (item.video_url || !item.image_url) {
    return '';
  }

  return '' +
    '<div class="tweet-image-wrap">' +
      '<img id="image-'+ item.tweetid +'"' +
        'src="'+ item.image_url +'"/>' +
    '</div>'
  ;
}

function fmtTweetVideo(item) {
  if (!item.video_url) {
    return '';
  }

  return '' +
    '<div class="tweet-video-wrap">' +
      '<video id="video-'+ item.tweetid +'" class="video-js vjs-default-skin ' +
        'vjs-fluid vjs-big-play-centered" controls preload="auto" ' +
        'poster="'+ item.image_url +'">' +
        '<source src="'+ item.video_url +'" type="video/mp4" />' +
        '<p class="vjs-no-js">' +
          'To view this video please enable JavaScript, and consider upgrading to a web browser that ' +
          '<a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>' +
        '</p>' +
      '</video>' +
    '</div>'
  ;
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
  text = text.replace(/(^|)@(\w+)/gi, '<a href="//twitter.com/$2">$&</a>');  
  
  // linkify #hashtags
  text = text.replace(/(^|)#(\w+)/gi, '<a href="//twitter.com/search?q=%23$2">$&</a>');  

  return text;
}
