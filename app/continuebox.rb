class ContinueBox

  attr_accessor :x, :y, :w, :h, :text, :lines, :page, :line_height

  def initialize box, font=nil
    @x = box.x
    @y = box.y
    # W and H are in characters, not pixels
    # Make sure the H you set leaves room for the "..." at the bottom
    @w = box.w
    @h = box.h
    @font = box.font
    @text = ""
    @lines = []
    # TODO: page currently isn't used, but could be added to the "..." line for context,
    # especially if you add a way to calculate the total number of pages.
    @page = 0
    @line_number = 0
    @line_height = 26
    @more = "..."
  end
  
  def on_last_page
    (@line_number + @h) >= @lines.length
  end
  
  def << story
    @text = story
    @lines = $args.string.wrapped_lines @text, @w
  end
  
  def advance
    next_line = @line_number + @h
    if next_line >= @lines.length
      return false
    else
      @page += 1
      @line_number = next_line
    end
  end
  
  def back
    if @line_number == 0
      return false
    end
    @line_number = @line_number - @h
    if @line_number < 0
      @line_number = 0
    end
    if @page > 0
      @page -= 1
    end
  end
  
  def reset
    @line_number = 0
    @page = 0
  end
  
  def labels
    res = []
    @h.times do |disp_row|
      next_line = @line_number + disp_row
      if(next_line < @lines.length)
        anchor_y = @y - (@line_height * disp_row)
        anchor_x = @x
        line = @lines[next_line].strip
        res << { x: anchor_x, y: anchor_y, text: line, font: @font }
      end
    end
    if @line_number + @h < @lines.length
      res << [ @x, @y - (@line_height * @h), @more, @font ]
    end
    return res
  end
  
  def draw surface
    labels.each do |s|
      surface.labels << s
    end
  end
  
  def serialize
    {
      x: @x,
      y: @y,
      w: @w,
      h: @h,
      text: @text,
      page: @page,
      line_number: @line_number
    }
  end
  
  def to_s
    serialize.to_s
  end
  
  def inspect
    serialize.to_s
  end
end