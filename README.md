The Warbride Engine is a collection of classes to ease making visual novels using the DragonRuby Game Toolkit.

`main.rb` contains example usage of all of the classes in context.

# ContinueBox

This defines a text box that can store multiple lines of text, and page it based on the width and height (in characters and lines)

Takes a hash:

```ruby
{
  x: # x position of upper left corner
  y: # y position of upper left corner
  w: # width of a line in characters
  h: # height of the visible area in lines
  font: # display font, omit this to use the default DR font
}
```

Set its text using `<<` followed by a string containing all of the text that you want to display.

`.advance` moves the text forwards one page
`.back` moves the text back one page
`.reset` takes you back to the first page

Set `.line_height` to change the spacing between lines.

# StoryBox

This mates a ContinueBox with a DragonRuby label containing the name
of the speaking character.

Takes a hash:

```ruby
{
  body: {
    # this is the descriptor hash for a ContinueBox
    x: # x position of the body text
    y: # y position of the body text
    w: # width in characters
    h: # height in lines
    font: # font to use for body text
  },
  name: {
    # descriptor hash for a label, but without any text
    x: # x position of the name
    y: # y position of the name
    font: # font to use for the name
  }
}
```

Passes through `.advance`, `.back`, and `.reset`; supports `<<` but requires a hash with `:name` and `:text` fields instead of just text.

# StoryEvent

This is the base unit of time, essentially a section of uninterrupted dialogue.

The constructor only takes the StoryBox that it will be writing to.

Once constructed, use `<<` to add dialogue event hashes with the following format:

```ruby
args.state.story << {
  name: "whoever is speaking",
  text: %Q(
Everything that one character says at a particular time.
The %Q notation in Ruby is a variant of the Heredoc, a
multiline string that can be used for long sections of
text. You could also pull this as a string from a text
file that you keep somewhere else, and in fact that is
probably better practice.

There is a .strip at the end of this doc to remove the
blank first line at the top of the Heredoc.
).strip
}
```

Any number of these dialogue event hashes can be appended to a StoryEvent, and they will all play together in sequence. It's possible to use `.advance` and `.back` here just like as before, this will move through dialogue pages when they are available, and will move between dialogue events when it reaches the last page of a particular event.
