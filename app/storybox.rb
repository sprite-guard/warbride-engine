require "app/continuebox.rb"

class StoryBox

  attr_accessor :body

  # descriptor format: 
  # StoryBox.new({
  #   body: {x: 310, y: 230, w: 60, h: 7, font: "font/euler.otf"},
  #   name: {x: 310, y: 280, font: "font/euler.otf"}
  # })
  # body has the font, x and y coordinates of the text box,
  # and the width and height in characters and lines;
  # name just has the location and font of the name box,
  # which is assumed to be a single line.
  
  def initialize desc
    @body = ContinueBox.new desc[:body]
    @name = desc[:name]
    @speaker = false
  end
  
  def draw surface
    @body.draw surface
    if @speaker
      @name[:text] = @speaker
      surface.labels << @name
    else
      @name[:text] = nil
    end
  end
  
  def << dialogue
    @speaker = dialogue[:name]
    @body << dialogue[:text]
  end
  
  def advance
    @body.advance
  end
  
  def back
    @body.back
  end
  
  def reset
    @body.reset
  end
  
end