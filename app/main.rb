require "app/storybox.rb"
require "app/storyevent.rb"

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
      body: {x: 310, y: 230, w: 59, h: 7, font: "font/euler.otf"},
      name: {x: 310, y: 280, font: "font/euler.otf"}
    })
    
    args.state.story = StoryEvent.new(args.state.layout.dialogue)
    
    args.state.story << {
      name: "Warbride",
      text: "I am Warbride! I am wedded to war! Conquest is my love, and battle is my passion. The whole world shall bow before me, and all who oppose me will fall in their time. If you love life, surrender now, but if you do not, then face me in battle."
    }
    
    args.state.story << {
      name: "Some guy",
      text: %Q(
      That's a nice speech, very inspirational. Tell me though, does it work for you? It sounds like you've rehearsed it pretty well, maybe you've used it on many other warriors, many of them much more weak-willed than I am. So tell me, has it ever worked for you, even on the most timid of opponents?
      
      If you need time to think of one, I can wait. I'm in no rush.
    ).strip
    }
    
    args.state.story << {
      name: "Warbride",
      text: %Q(
        The great general Another Guy, known for his wisdom and his devotion to his people, showed great prudence.
        
        He knew that he could not beat me, and he knew that I would crush his people and burn their villages, and take their food for my soldiers. Instead he came, not to fight, but to bargain.
        
        I will admit that I was disappointed, but I am only half-barbaric, and so I put forward my demands to him. He, putting the wellbeing of his people above his own ego and desire for conquest, handed over rulership.
        
        It is not so bad, living in my empire. We are prosperous, and cosmopolitan. Within my empire there is complete freedom of movement, and so all of the cultures absorbed into my empire mingle freely, and exchange their ideas.
        
        You think that because I am a barbarian, my land must be barbaric, but I have no desire to crush a people who are loyal to me, who submit to my law and my rule.
        
        But how is your land? Do your people prosper?
      ).strip
    }
    
    args.state.story << {
      name: "Some Guy's lieutenant",
      text: "Do not believe her, my lord. Word of her atrocities has spread throughout the land. She brings only death and suffering wherever she goes."
    }
    args.state.story.start
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
    args.state.story.advance
  end
  if args.inputs.keyboard.key_down.backspace
    args.state.story.back
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