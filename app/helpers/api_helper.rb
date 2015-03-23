module ApiHelper


  def get_time #chop off the last word in Time.now
    arr = Time.now.split(" ")
    return "#{arr[0]} #{arr[1]}"
  end

end
