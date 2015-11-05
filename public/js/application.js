function populateFbook(el, item) {
  $(el).append(fmtOneFbook(item));
  if (item.video_url) {
    videojs("video-"+item.postid);
  }
}

function fmtOneFbook(item) {
  return '' +
    '<div class="sm-wrap">' +
      '<div class="sm-body">' +
        '<div class="image">' +
          fmtFbookVideo(item) +
          fmtFbookImage(item) +
        '</div>' +
        '<div class="caption">' +
          '<p>' + ellipsize(item.caption, 150) + '</p>' +
          '<p class="link">(<a href="' + item.link + '">via Facebook</a>)</p>' +
        '</div>' +
      '</div>' +
      '<div class="sm-footer">' +
        '<p>' + 
          '<span title="Time posted: '+fmtFbookTimeTitle(item.posttime)+'" class="posttime">' + fmtFbookTime(item.posttime) + '</span>' +
          '<span class="social-area-icon"><a href="//www.facebook.com/TXSTATEU/"><i class="fa fa-facebook-official"></i></a></span>' +
        '</p>' + 
      '</div>' +
    '</div>'
  ;
}

function fmtFbookImage(item) {
  if (item.video_url) {
    return '';
  }

  return '<a href="'+ item.link +'">' +
      '<img src="' + item.image_url + '">' +
    '</a>';
}

function fmtFbookVideo(item) {
  if (!item.video_url) {
    return '';
  }

  return '' +
    '<div class="fb-video-wrap">' +
      '<video id="video-'+ item.postid +'" class="video-js vjs-default-skin ' +
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

function fmtFbookTime(time) {
  return moment(time).fromNow();
}

function fmtFbookTimeTitle(time) {
  //24 Sep 2015, 23:31:27 (UTC)
  return moment(time).format('D MMM YYYY, HH:mm:ss (Z)')
}

function populateInsta(el, item) {
  $(el).append(fmtOneInsta(item));
  if (item.video_url) {
    videojs("video-"+item.postid);
  }
}

function fmtOneInsta(item) {
  return '' +
    '<div class="sm-wrap">' +
      '<div class="sm-body">' +
        '<div class="ig-image">' +
          '<div class="image">' +
            fmtInstaVideo(item) +
            fmtInstaImage(item) +
          '</div>' +
          '<div class="caption">' +
            '<p >' + linkifyInsta(ellipsize(item.caption, 150)) + '</p>' +
            '<p class="link">(<a href="' + item.link + '">via Instagram</a>)</p>' +
          '</div>' +
        '</div>' +
      '</div>' +
      '<div class="sm-footer">' +
        '<p>' + 
          '<span title="Time posted: '+fmtInstaTimeTitle(item.posttime)+'" class="posttime">' + fmtInstaTime(item.posttime) + '</span>' +
          '<span class="social-area-icon"><a href="//instagram.com/txst"><i class="fa fa-instagram"></i></a></span>' +
        '</p>' +
      '</div>' +
    '</div>'
  ;
}

function fmtInstaImage(item) {
  if (item.video_url) {
    return '';
  }

  return '<a href="'+ item.link +'">' +
      '<img src="' + item.image_url + '">' +
    '</a>';
}

function fmtInstaVideo(item) {
  if (!item.video_url) {
    return '';
  }

  return '' +
    '<div class="insta-video-wrap">' +
      '<video id="video-'+ item.postid +'" class="video-js vjs-default-skin ' +
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

function fmtInstaTime(time) {
  return moment(time).fromNow();
}

function fmtInstaTimeTitle(time) {
  //24 Sep 2015, 23:31:27 (UTC)
  return moment(time).format('D MMM YYYY, HH:mm:ss (Z)')
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
    '<div class="sm-wrap">' +
      fmtTweetVideo(item) +
      fmtTweetImage(item) +
      '<div class="sm-body">' +
        '<div class="tweet-header">' +
          '<a class="screen-name" href="//twitter.com/' + item.screen_name + '">' +
            '@' + item.screen_name +
          '</a>' +
          '<span class="display-name">' + item.display_name + '</span>' +
        '</div>' +
        '<div class="tweet-body">' +
          '<p>' + linkifyTweet(item.text) + '</p>' +
        '</div>' +
      '</div>' +
      '<div class="sm-footer">' +
        '<p>' + 
          '<a title="Time posted: '+fmtTweetTimeTitle(item.tweettime)+'" class="posttime" href="'+item.link+'">' + 
            fmtTweetTime(item.tweettime) + 
          '</a>' +
          '<span class="social-area-icon"><a href="//instagram.com/txst"><i class="fa fa-twitter"></i></a></span>' +
        '</p>' + 
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

function fmtTweetTimeTitle(time) {
  //24 Sep 2015, 23:31:27 (UTC)
  return moment(time).format('D MMM YYYY, HH:mm:ss (Z)')
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

// truncate string and append ellipsis if length is greater than len.
// truncates on word boundary if possible. 
function ellipsize(s, len) {
  if (s.length <= len) {
    return s;
  }

  var wb = s.substr(len-10, 20).lastIndexOf(' ') - 10;
  if (wb < -10) {
    wb = 0;
  }

  return s.substr(0,len + wb) + '&hellip;';
}
