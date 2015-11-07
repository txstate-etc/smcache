var maintmpl = Handlebars.compile( $("#template-main").html());
var igmaintmpl = Handlebars.compile( $("#template-igmain").html());
var twmaintmpl = Handlebars.compile( $("#template-twmain").html());
var fbmaintmpl = Handlebars.compile( $("#template-fbmain").html());
var fbtmpl = Handlebars.compile( $("#template-facebook").html());
var igtmpl = Handlebars.compile( $("#template-instagram").html());
var twtmpl = Handlebars.compile( $("#template-twitter").html());
Handlebars.registerPartial('partial-video', $("#partial-video").html());

var videos = [];
function createVideo(id) {
  videos.push(videojs(id));
}

function destroyVideos() {
   videos.forEach(function(v) {
     v.dispose();
   })
   videos = [];
}

function populateFbook(el, item) {
  $(el).append(fbtmpl(item));
  if (item.video_url) {
    createVideo("video-"+item.postid);
  }
}

function populateInsta(el, item) {
  $(el).append(igtmpl(item));
  if (item.video_url) {
    createVideo("video-"+item.postid);
  }
}

Handlebars.registerHelper('linkifyInsta', function(text) {
  if (!text) {
    return '';
  }

  // linkify urls
  text = text.replace(/(https?:\/\/\S+)/gi, '<a href="$1">$1</a>');  
  
  // linkify @screen_names
  text = text.replace(/(^|)@(\w+)/gi, '<a href="//instagram.com/$2/">$&</a>');  
  
  // linkify #hashtags
  text = text.replace(/(^|)#(\w+)/gi, '<a href="//instagram.com/explore/tags/$2/">$&</a>');  

  // return new Handlebars.SafeString(text);
  return text;
});

function populateTweet(el, item) {
  item.postid = item.tweetid;
  item.posttime = item.tweettime;
  $(el).append(twtmpl(item));
  if (item.video_url) {
    createVideo("video-"+item.tweetid);
  }
}

Handlebars.registerHelper('fmtTime', function(time) {
  t = moment(time);
  if (t.isBefore(moment().subtract(7, 'days'))) {
    return t.format('h:mm A - D MMM YYYY')
  } else {
    return t.fromNow();
  }
});

Handlebars.registerHelper('fmtTimeTitle', function(time) {
  //24 Sep 2015, 23:31:27 (UTC)
  return moment(time).format('D MMM YYYY, HH:mm:ss (Z)')
});

Handlebars.registerHelper('linkifyTweet', function(text) {
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

  // return new Handlebars.SafeString(text);
  return text;
});

// truncate string and append ellipsis if length is greater than len.
// truncates on word boundary if possible. 
Handlebars.registerHelper('ellipsize', function(s, len) {
  if (!s || s.length <= len) {
    return s;
  }

  var wb = s.substr(len-10, 20).lastIndexOf(' ') - 10;
  if (wb < -10) {
    wb = 0;
  }

  return s.substr(0,len + wb) + '&hellip;';
  // return new Handlebars.SafeString(ret);
});
