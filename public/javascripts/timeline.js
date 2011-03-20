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

      homeTimeline: function(since_id) {
	  var xhr = new XMLHttpRequest();
	  var url = "http://localhost/statuses/home_timeline";

	  if (since_id != undefined) {
	      url += "?since_id=" + since_id
	  }

	  xhr.open("GET", url, true);
	  xhr.withCredentials = true;
	  xhr.onload = function() {
	      var tweets = JSON.parse(this.responseText).reverse();
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
	  }
	  xhr.send();
      },

      update: function() {
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
