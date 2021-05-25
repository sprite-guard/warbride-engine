require "app/storybox.rb"

def quick_reset
  $gtk.reset
  $gtk.console.animation_duration = 0
end

quick_reset

def setup args

  if(args.state.tick_count == 0)
    args.state.session_tick = 0
    args.state.debug_messages = []
    $gtk.console.animation_duration = 0
    args.state.layout.dialogue = StoryBox.new({
      body: {x: 310, y: 230, w: 60, h: 7, font: "font/euler.otf"},
      name: {x: 310, y: 280, font: "font/euler.otf"}
    })
    
    args.state.layout.dialogue << {
      name: "Warbride",
      text: %Q(
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non nulla nec mauris vulputate consequat a eget risus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nullam non neque eu erat rutrum finibus. Curabitur iaculis risus justo, non congue magna iaculis ut. Nunc ipsum sapien, cursus eget pharetra nec, molestie eget mauris. Praesent cursus mi in elementum dictum. Morbi dictum odio magna, nec malesuada turpis porttitor at. Aliquam aliquam accumsan metus at auctor. Vivamus urna enim, commodo nec molestie sed, posuere eu tellus. Aenean elementum nisl sed posuere aliquet. Integer aliquet, ex sed rhoncus tempor, mi velit tempus enim, in imperdiet lacus neque id diam. Sed vitae urna lacinia, dignissim odio eget, maximus felis. Sed sapien purus, rutrum nec metus a, semper facilisis ex.

Donec id neque et magna ornare dapibus vitae in neque. Morbi ex sem, molestie ut sagittis eget, bibendum in odio. Maecenas dignissim, est quis semper volutpat, ipsum ipsum posuere enim, ac lobortis risus leo tincidunt arcu. Ut sed vulputate dolor, iaculis laoreet libero. Cras velit metus, pretium eget sodales vitae, venenatis a nisl. Donec vitae augue dictum, porta nunc id, mattis velit. Phasellus ornare lorem vitae elit hendrerit, mollis auctor mauris maximus. Donec fermentum ligula a nisl fermentum consectetur. Duis massa elit, condimentum et ligula et, lobortis porttitor tellus. Curabitur in sem volutpat, commodo ex ac, tincidunt turpis. Integer ultricies tristique orci vitae ullamcorper.
      ).strip
    }
  end
  
  args.state.layout.background ||= {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    path: 'art/desert.png',
    angle: 0
  }
  
  args.state.layout.text_box ||= {
    x: 290,
    y: 0,
    w: 700,
    h: 300,
    path: 'art/text box.png',
    angle: 0
  }
end
 
def tick args
  setup args
  if args.inputs.keyboard.key_down.space
    args.state.layout.dialogue.advance
  end
  if args.inputs.keyboard.key_down.backspace
    args.state.layout.dialogue.back
  end
  draw args
  args.state.session_tick += 1
  debug_display args
end

def draw args
  args.outputs.sprites << args.state.layout.background
  args.outputs.sprites << args.state.layout.text_box
  args.state.layout.dialogue.draw args.outputs
end

def debug_log message

  $args.state.debug_messages << message

end

def debug_display args

  max_messages = 35
  message_height = 20
  
  if(args.state.debug_messages.length > max_messages)
    message_offset = -max_messages
  else
    message_offset = 0
  end
  
  line_offset = 0
  
  args.state.debug_messages[message_offset,max_messages].each do |message|
    args.outputs.labels << [ 10, 720-line_offset, message ]
    line_offset += message_height
  end
end