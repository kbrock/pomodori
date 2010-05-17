class Countdown
  attr_accessor :secs, :callback
  
  def initialize(secs, block = lambda {})
    @secs = secs
    @callback = block
  end

  #total number of seconds
  def doubleValue()
	@secs
  end

  # minutes portion of time left
  def mins
    @secs / 60
  end

  #seconds portion of time left
  def secs
    @secs % 60
  end
  
  def tick
    if @secs > 1
      @secs -= 1
    else
      @secs = 0
      @callback.call
    end
  end
  
end
