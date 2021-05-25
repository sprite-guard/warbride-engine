class StoryEvent

  def initialize storybox
    @box = storybox
    @events = []
    @event_index = 0
  end
  
  def << event
    @events << event
  end
  
  def start
    @box << @events[@event_index]
  end
  
  def advance
    if @box.advance
      return true
    else
      @box.reset
      @event_index += 1
      if @event_index >= @events.length
        return false
      else
        @box << @events[@event_index]
      end
    end
  end
  
  def back
    if @box.back
      return true
    else
      if @event_index > 0
        @event_index -= 1
        @box << @events[@event_index]
      else
        return false
      end
    end
  end
  
  def draw surface
    @box.draw surface
  end
  
end
