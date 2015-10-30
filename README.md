# nmea_plus
Ruby gem for NMEA (plus other similar formats) message parsing

## Source data
This gem was coded to the unoffical spec found here: http://www.catb.org/gpsd/NMEA.txt

## Organization
A very trivial parser extracts the message type and checksum information, passing them directly to a message factory class.  The factory classes read the data type and create the appropriate class through reflection.

The classes are by default named after the message types they support.  However, NMEA supports so-called "Standard Sentences" -- talker-independent commands -- which need to be attempted if a given message class does not exist.  These can be configured in the `self.alternate_data_type` method of a message factory subclass.

Message classes are given the message prefix (e.g. "$"), payload (string of comma-separated fields), and checksum string (without the `*`).  They are also given the "interpreted data type" -- the possible alternate data type produced above.  Messages immediately split the payload on the commas, and any subclasses of messages should expose those fields as proper data types with proper names.

## Testing
* run `rspec`

## Packaging the Gem

* `rake -f parser/Rakefile`
* `gem build nmea_plus.gemspec`
