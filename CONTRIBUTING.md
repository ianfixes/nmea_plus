# Contributing to the NMEAPlus gem

NMEAPlus uses a very standard GitHub workflow.

1. Fork the repository on github
2. Generate the parser files with `rake -f parser/Rakefile`
3. Make your desired changes
4. Push to your personal fork
5. Open a pull request

Pull requests will trigger a Travis CI job.  The following two commands will be expected to pass (so you may want to run them locally before opening the pull request):

 * `rubocop -D` - code style tests
 * `rspec` - functional tests

Be prepared to write tests to accompany any code you would like to see merged.


## Code Organization and Operation

A very trivial parser extracts the message type and checksum information, passing them directly to a message factory class.  The factory classes read the data type and instantiate the appropriate object through reflection.

The classes are by default named after the message types they support.  However, NMEA supports so-called "Standard Sentences" -- talker-independent commands -- which need to be attempted if a given message class does not exist.  These can be configured in the `self.alternate_data_type` method of a message factory subclass.

Message classes are given the message prefix (e.g. "$"), payload (string of comma-separated fields), and checksum string (without the `*`).  They are also given the "interpreted data type" -- the possible alternate data type produced above.  Messages immediately split the payload on the commas, and any subclasses of messages should expose those fields as proper data types with proper names.

A similar pattern applies to the parsing of AIS message payloads.


### Adding a new data type

Let's say we've defined a new NMEA message called MYMSG and want our decoder to properly parse it.

1. Edit `gem/lib/nmea_plus/message/nmea/mymsg.rb`
2. Stub it out as follows:

```ruby
require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class MYMSG < NMEAPlus::Message::NMEA::NMEAMessage
      end
    end
  end
end
```

3. Add `require_relative "message/nmea/mymsg"` to `gem/lib/nmea_plus/nmea_message_factory.rb`
4. Add tests in `spec/parser_spec.rb`
5. Add accessor methods in NMEAPlus::Message::NMEA::MYMSG, and appropriate tests.

The following metaprogramming feature has been added to facilitate this:

```ruby

field_reader :my_field, 2, :_integer

# this is equivalent to the following:

def my_field
  _integer(@fields[2])
end
```


## Packaging the Gem

* `rake -f parser/Rakefile`
* `gem build nmea_plus.gemspec`
