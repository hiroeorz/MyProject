function Timeline() {}

var Timeline = function() {this.init();}

  Timeline.prototype = {
      init: function() {
	  this.latest_id = null;
	  this.update_cycle = 30 * 1000;
      },

      start: function() {
	  this.homeTimeline(this.latest_id);
	  setTimeout(function() {timeline.start(timeline.update_cycle);},
		    this.update_cycle);
      },

      update: function() {
	  try {
	      timeline.updateXHR2();
	  } catch(e) { /* not support XMLHttpRequest */
	      timeline.updateIframe();
	  }
      },

      updateIframe: function() {
	  var text = $("#tweet_text").attr("value");

	  var d = document;
	  var f = document.getElementById("tweet-form");
	  var b = document.getElementById("tweet-button");

	  // クロスドメインポスト用隠し iframe
	  var i = d.createElement('iframe');
	  i.style.display = 'none';
	  d.body.appendChild(i);
	  
	  // レスポンスイベント取得用隠し iframe
	  var i2 = d.createElement('iframe');
	  i2.name = 'postresult';
	  i2.style.display = 'none';
	  d.body.appendChild(i2);

	  // レスポンス時イベント登録
	  i2.contentWindow.addEventListener('unload', function(e) {
	      timeline.homeTimeline(timeline.latest_id);
	      $("#tweet_text").val("");
	  }, false);

	  // クロスドメインへの POST メソッド送信
	  var iDoc = i.contentWindow.document;
	  iDoc.open();
	  iDoc.write('<form method="POST" action="http://localhost/statuses/update" target="postresult">');
	  iDoc.write('<input type="hidden" name="status" value="' + text + '" />');
	  iDoc.write('</form>');
	  iDoc.write('<script>window.onload = function(){document.forms[0].submit();}</script>');
	  iDoc.close();	  
      },

      updateJquery: function() {
	  alert("jquery post");
	  var text = $("#tweet_text").attr("value");
	  var url = "http://localhost/statuses/update";
	  $.post(url, {status: encodeURIComponent(text)},
		function(data, status) {
		    alert(data);
		})
      },

      updateXHR2: function() {
	  var text = $("#tweet_text").attr("value");
	  var xhr = new XMLHttpRequest();
	  var url = "http://localhost/statuses/update";

	  xhr.open("POST", url, true);
	  xhr.withCredentials = true;
	  xhr.onload = function() {
	      timeline.homeTimeline(timeline.latest_id);
	      $("#tweet_text").attr("value", "");
	  }

	  xhr.setRequestHeader('Content-Type', 
			       'application/x-www-form-urlencoded');
	  xhr.send("status=" + encodeURIComponent(text));
      },

      homeTimeline: function(since_id) {
	  this.homeTimelineJSONP(since_id);
      },

      homeTimelineJSONP: function(since_id) {
	  var url = "http://localhost/statuses/home_timeline";
	  url += "?callback=?";

	  if (since_id != undefined) {
	      url += "&since_id=" + since_id
	  }

	  $.getJSON(url, function(jsonData) {
	      timeline.setTweetDataToTimeline(jsonData);
	  });
      },

      homeTimelineXHR2: function(since_id) {
	  var xhr = new XMLHttpRequest();
	  var url = "http://localhost/statuses/home_timeline";

	  if (since_id != undefined) {
	      url += "?since_id=" + since_id
	  }

	  xhr.open("GET", url, true);
	  xhr.withCredentials = true;
	  xhr.onload = function() {
	      timeline.setTweetDataToTimeline(this.responseText);
	  };
	  xhr.send();
      },

      setTweetDataToTimeline: function(jsonData) {
	  var tweets = JSON.parse(jsonData).reverse();
	  var now_time_msec = new Date().getTime();

	  for (var i = 0; i < tweets.length; i++) {

	      var tweet = tweets[i];
	      var user = tweet.user;
	      
	      var tweetTime = Date.parse(tweet.created_at);
	      var time_offset_msg = 
		  timeline.getTimeSinceMessage(now_time_msec, tweetTime);
	      
	      var user_name = document.createElement("div");
	      $(user_name).addClass("tweet-username");
	      user_name.innerHTML = user.name;
	      $(user_name).append("<span class='timeline-time'>" + 
				  time_offset_msg + 
				  "</span>");
	      
	      var li = document.createElement("li");
	      var img_div = document.createElement("div");
	      $(img_div).addClass("img-div");
	      
	      var text_div = document.createElement("div");
	      $(text_div).addClass("text-div");
	      
	      var clear_div = document.createElement("div");
	      $(clear_div).css("clear", "both");
	      
	      var imgStr = "<img src='" + user.profile_image_url + "' />"
	      $(img_div).append(imgStr);
	      
	      var p = document.createElement("p");
	      p.innerHTML = tweet.text;
	      $(text_div).append(p);
	      
	      var body_div = document.createElement("div");
	      $(body_div).addClass("body-div");
	      
	      
	      $(body_div).append(img_div);
	      $(body_div).append(text_div);
	      $(body_div).append(clear_div);
	      $(li).append(body_div);
	      $(li).append(user_name);
	      $(li).append(clear_div);
	      
	      $("#tweets").prepend(clear_div)
	      $("#tweets").prepend(li);
	      
	      if (timeline.latest_id == null ||
		  parseInt(timeline.latest_id) < parseInt(tweet.id)) {
		  timeline.latest_id = parseInt(tweet.id);
	      }
	  }
      },

      getTimeSinceMessage: function(fromTime, toTime) {
	  var time_offset = parseInt((fromTime - toTime) / 1000 / 60);
	  var time_offset_msg = time_offset + "分前";
	  
	  if (time_offset > 60) {
	      time_offset_msg = parseInt(time_offset / 60) + "時間前";
	  }
	  if (time_offset > (60 * 24)) {
	      time_offset_msg = parseInt(time_offset / 60 / 24) + "日前";
	  }

	  return time_offset_msg;
      }

  }

var timeline = new Timeline;
