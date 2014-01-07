# Template Inspector

This Chrome Extension creates a context menu item called "Inspect Template".  Clicking this will open your editor to
 the file which generated the template.

This is enabled through special comments which are generated by the server.  Have your server wrap ever render
with the following syntax:

```html
<!--begin partial /full/path/to/your/file.rb-->
<p>Template contents here</p>
<!--end partial-->
```

Note that HTML comments can not be nested.  Be sure that you have no multiline HTML comments surrounding render calls.

### Leap compatibility:

If you have a leap set up, this plugin will recognize hand position as a cursor, and allow you to tilt your hand in a
"turning over a rock"-like gesture, which will open your editor at the desired location.

### Rails compatibility:


Add this snippet to your initializers directory:

```ruby
module ActionView
  class PartialRenderer < AbstractRenderer

    def render_partial_with_annotation
      identifier = @template ? @template.identifier : @path
      "<!--begin partial #{identifier}-->#{render_partial_without_annotation}<!--end partial-->".html_safe
    end

    alias_method_chain :render_partial, :annotation

  end
end
```


### Building:

```
> cd template_inspector/coffee
> coffee -w -c -o ../js ./
```