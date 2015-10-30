module ConcertHelper
  def concert_duration_opts
    result = []
    (30..240).step(5) do |x|
      if x < 60
        result << [x, x.to_s + 'min']
      else
        if x % 60 == 0
          result << [x, (x/60).to_s + 'h']
        else
          result << [x, (x/60).to_s + 'h' + (x%60).to_s + 'min']
        end
      end 
    end
  Enum.new(result)
  end
end
