# nmea_plus
Ruby gem for NMEA (plus other similar formats) message parsing

## Organization
A very trivial parser extracts the message type and checksum information, passing them directly to a message factory class.  The factory classes read the data type and create the appropriate class through reflection.  The classes are therefore named after the message types they support.

## Testing
* run `rspec`

## Packaging the Gem

* `rake -f parser/Rakefile`
* `gem build nmea_plus.gemspec`
