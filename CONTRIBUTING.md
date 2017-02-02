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


### Adding a new NMEA data type

Let's say we've defined a new NMEA message called MYMSG and want our parser to properly parse it.

1. Edit `lib/nmea_plus/message/nmea/mymsg.rb`
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

3. Add `require_relative "message/nmea/mymsg"` to `lib/nmea_plus/nmea_message_factory.rb`
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

### Adding a new AIS VDM message type

Let's say we've defined a new AIS VDM message type 28 and want our decoder to properly decode it.

1. Edit `lib/nmea_plus/message/ais/vdm_payload/vdm_msg28.rb`
2. Stub it out as follows:

```ruby
require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsg28 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
        end
      end
    end
  end
end
```

3. Add `require_relative "vdm_payload/vdm_msg28.rb"` to `lib/nmea_plus/message/ais/vdm.rb`
4. Add tests in `spec/ais_spec.rb`

The following metaprogramming feature has been added to facilitate this:

```ruby

payload_reader :my_field, 11, 22, :_I, 33, 44

# this is equivalent to the following:
def my_field
  # let v = the 22 bits starting from field 11
  # format v using _I() with arguments 33 and 44
  # based on our convention, this means that if 44 == _I(args), return nil
end
```


### Adding a new binary subtype to an AIS VDM message

Let's say we've defined a new binary payload type for AIS VDM message type 6 and want our decoder to properly decode it.
This message type uses DAC 333 and FID 444

1. Edit `lib/nmea_plus/message/ais/vdm_payload/vdm_msg6d333f444.rb`
2. Stub it out as follows:

```ruby
require_relative 'vdm_msg6_dynamic_payload'  # or msg8 as appropriate

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsg6d333f444 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload
        end
      end
    end
  end
end
```

3. Add `require_relative 'vdm_msg6d235f10'` to `lib/nmea_plus/message/ais/vdm_msg6.rb`
4. Add tests in `spec/ais_spec.rb`

The same metaprogramming feature (`payload_reader`) is available, and the bit offsets still work from the beginning of the message.


## Packaging the Gem

* Merge pull request with new features
* `rake -f parser/Rakefile`
* Bump the version in lib/nmea_plus/version.rb and change it in README.md (since rubydoc.info doesn't always redirect to the latest version)
* `git add README.md lib/nmea_plus/version.rb`
* `git commit -m "vVERSION bump"`
* `git tag -a vVERSION -m "Released version VERSION"`
* `gem build nmea_plus.gemspec`
* `gem push nmea_plus-VERSION.gem`
* `git push upstream`
* `git push upstream --tags`
