module ConcertHelper
  def concert_duration_opts
    result = []
    (30..240).step(5) do |x|
      result << [x, str_minutes_to_hours(x)]
    end
    Enum.new(result)
  end
  
  def time_format(datetime)
    datetime.strftime('%H:%M') unless datetime.blank?
  end
  
  def str_minutes_to_hours(minutes)
    if minutes < 60
      minutes.to_s + 'min'
    else
      if minutes % 60 == 0
        (minutes/60).to_s + 'h'
      else
        (minutes/60).to_s + 'h' + (minutes%60).to_s + 'min'
      end
    end
  end
  
  def str_payment_type(concert)
    result = Concert::PAYMENT_TYPE[@concert.payment_type] + ' - '
    print concert.payment_type.class
    if concert.payment_type == 'fixedpay'
      result += '$ ' + concert.payment.to_s
    else
      result += concert.payment.to_s + ' %'
    end
  end
end
