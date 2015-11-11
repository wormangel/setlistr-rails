module SetlistHelper
  def seconds_to_hms(seconds)
    if seconds < 60
      seconds.to_s + 's'
    elsif seconds < 3600
      if seconds % 60 == 0
        (seconds/60).to_s + 'min'
      else
        (seconds/60).to_s + 'min' + "%02d" % (seconds%60).to_s + 's'
      end
    else
      if seconds % 3600 == 0
        (seconds/3600).to_s + 'h'
      else
        if (seconds/3600) % 60 == 0
          (seconds/3600).to_s + 'h' + "%02d" % ((seconds%3600) / 60).to_s + 'min'
        else
          (seconds/3600).to_s + 'h' + "%02d" % ((seconds%3600) / 60).to_s + 'min' + "%02d" % ( (seconds%3600) % 60 ).to_s + 's'
        end
      end
    end
  end
end
