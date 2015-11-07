module SongHelper
  def label_for_discoverable_field(label)
    (label + ' ' + '<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>').html_safe
  end
  
  def str_seconds_to_minutes(seconds)
    if seconds < 60
      seconds.to_s + 's'
    else
      if seconds % 60 == 0
        (seconds/60).to_s + ':00'
      else
        (seconds/60).to_s + ':' + "%02d" % (seconds%60).to_s
      end
    end
  end
  
  def youtube_url(youtube_id)
    "https://www.youtube.com/watch?v=#{youtube_id}"
  end
  
  def youtube_embed_url(youtube_id)
    "https://www.youtube.com/embed/#{youtube_id}?autoplay=0&origin=#{root_path}"
  end
end