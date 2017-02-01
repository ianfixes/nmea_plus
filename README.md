# NMEA (GPS) and AIS Parser / Decoder for Ruby (nmea_plus)

[![Gem Version](https://badge.fury.io/rb/nmea_plus.svg)](https://rubygems.org/gems/nmea_plus)
[![Build Status](https://travis-ci.org/ifreecarve/nmea_plus.svg)](https://travis-ci.org/ifreecarve/nmea_plus)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/nmea_plus/1.0.19)

[NMEA Plus](https://github.com/ifreecarve/nmea_plus) is a Ruby gem for parsing and decoding "GPS" messages: NMEA, AIS, and any other similar formats of short messaging typically used by marine equipment.  It provides convenient access (by name) to the fields of each message type, and a stream reader designed for use with Ruby Blocks.


## Install

`gem install nmea_plus`

## Example

In its most basic use, you can decode messages as follows:

```ruby
require 'nmea_plus'

decoder = NMEAPlus::Decoder.new
message = decoder.parse("$GPGLL,4916.45,N,12311.12,W,225444,A*00")
# message data -- specific to this message type
puts message.latitude     # prints 49.27416666666666666666
puts message.longitude    # prints -123.18533333333333333
puts message.fix_time     # prints <today's date> 22:54:44 <your local time zone offset>
puts message.valid?       # prints true
puts message.faa_mode     # prints nil

# metadata
puts message.checksum_ok? # prints false -- because this checksum is made up
puts message.original     # prints "$GPGLL,4916.45,N,12311.12,W,225444,A*00"
puts message.data_type    # prints "GPGLL" -- what was specified in the message
puts message.interpreted_data_type  # prints "GLL" -- the actual container used

# metadata that applies to multipart messages (also works for single messages)
puts message.all_messages_received? # prints true
puts message.all_checksums_ok?      # prints false -- checksum is still made up

# safer way to do what we did above
if "GPGLL" == message.data_type     # Alternately, if "GLL" == message.interpreted_data_type
  puts message.latitude     # prints 49.27416666666666666666
  puts message.longitude    # prints -123.18533333333333333
  puts message.fix_time     # prints <today's date> 22:54:44 <your local time zone offset>
  puts message.valid?       # prints true
  puts message.faa_mode     # prints nil
end
```


Of course, decoding in practice is more complex than that.  Some messages can have multiple parts, and AIS messages have their own complicated payload.  NMEAPlus provides a `SourceDecoder` class that operates on `IO` objects (anything with `each_line` support) -- a `File`, `SerialPort`, etc.  You can iterate over each message (literally `each_message`), or receive only fully assembled multipart messages by iterating over `each_complete_message`.

```ruby
require 'nmea_plus'

input1 = "!AIVDM,2,1,0,A,58wt8Ui`g??r21`7S=:22058<v05Htp000000015>8OA;0sk,0*7B"
input2 = "!AIVDM,2,2,0,A,eQ8823mDm3kP00000000000,2*5D"
io_source = StringIO.new("#{input1}\n#{input2}")  # source decoder works on any IO object

source_decoder = NMEAPlus::SourceDecoder.new(io_source)
source_decoder.each_complete_message do |message|
  puts message_all_checksums_ok?                  # prints true -- the full message set has good checksums
  puts message_all_messages_received?             # prints true -- taken care of by each_complete_message
  if "AIVDM" == message.data_type
    puts message.ais.message_type                   # prints 5
    puts message.ais.repeat_indicator               # prints 0
    puts message.ais.source_mmsi                    # prints 603916439
    puts message.ais.ais_version                    # prints 0
    puts message.ais.imo_number                     # prints 439303422
    puts message.ais.callsign.strip                 # prints "ZA83R"
    puts message.ais.name.strip                     # prints "ARCO AVON"
    puts message.ais.ship_cargo_type                # prints 69
    puts message.ais.ship_dimension_to_bow          # prints 113
    puts message.ais.ship_dimension_to_stern        # prints 31
    puts message.ais.ship_dimension_to_port         # prints 17
    puts message.ais.ship_dimension_to_starboard    # prints 11
    puts message.ais.epfd_type                      # prints 0
    puts message.ais.eta                            # prints <this year>-03-23 19:45:00 <your local time zone offset>
    puts message.ais.static_draught                 # prints 13.2
    puts message.ais.destination.strip              # prints "HOUSTON"
    puts message.ais.dte?                           # prints false
  end
end

```

## NMEA (GPS) Parsing

This gem was coded to accept the standard NMEA messages defined in the official and unoffical specs found here:

* http://www.catb.org/gpsd/NMEA.txt
* http://www.nmea.org/Assets/100108_nmea_0183_sentences_not_recommended_for_new_designs.pdf

Because the message types are standard, if no override is found for a particular talker ID then the message will parse according to the command (the last 3 characters) of the data type.  In other words, `$GPGLL` will use the general `GLL` message type.  Currently, the following standard message types are supported:

> AAM, ALM, APA, APB,
> BEC, BER, BOD, BPI, BWC, BWR, BWW,
> DBK, DBS, DBT, DCN, DPT, DRU, DTM,
> FSI,
> GBS, GDA, GDF, GDP, GGA, GLA, GLC, GLF, GLL, GLP, GOA, GOF, GOP, GNS, GRS, GSA, GST, GSV, GTD, GXA, GXF, GXP,
> HCC, HCD, HDG, HDM, HDT, HFB, HSC, HTC, HVD, HVM,
> IMA, ITS,
> LCD,
> MDA, MHU, MMB, MSK, MSS, MTA, MTW, MWH, MWS, MWV,
> OLN, OLW, OMP, ONZ, OSD,
> R00, RMA, RMB, RMC, RNN, ROT, RPM, RSA, RSD, RTE,
> SBK, SCD, SCY, SDB, SFI, SGD, SGR, SIU, SLC, SNC, SNU, SPS, SSF, STC, STN, STR, SYS
> TDS, TEC, TEP, TFI, TGA, TIF, TPC, TPR, TPT, TRF, TRP, TRS, TTM,
> VBW, VCD, VDR, VHW, VLW, VPE, VPW, VTA, VTG, VTI, VWE, VWR, VWT
> WCV, WDC, WDR, WFM, WNC, WNR, WPL,
> XDR, XTE, XTR,
> YWP, YWS,
> ZDA, ZFO, ZTG

Support for proprietary NMEA messages is also possible.  PASHR is included as proof-of-concept.


## AIS Decoding

AIS message type definitions were implemented from the unofficial spec found here:
http://catb.org/gpsd/AIVDM.html

And some binary subtypes from the ITU spec found here:
https://www.itu.int/dms_pubrec/itu-r/rec/m/R-REC-M.1371-4-201004-S!!PDF-E.pdf

The AIS payload can be found in the payload field of a `VDM` message (aka `!AIVDM`, `!ABVDM`, `!SAVDM`) or `VDO` message (aka `!AIVDO`).  Currently, the following AIS message types are supported:

> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 24, 27

> Type 6 subtypes for DAC/FID: 1/0, 1/2, 1/3, 1/4, 1/5, 235/10, 1022/61

> Type 8 subtypes for DAC/FID: 1/0, 1/22, 1/31, 200/10, 366/56, 366/57


## Disclaimer

This module was written primarily from information scraped together on the web, with minimal testing on an actual device (an SR161 AIS receiver).  A lack of test cases -- especially for more obscure message types -- is a barrier to completeness.  Please don't entrust your life or the safety of a ship to this code without doing your own rigorous testing.


## Author

This gem was written by Ian Katz (ifreecarve@gmail.com) in 2015.  It's released under the Apache 2.0 license.


## See Also

* [Contributing](CONTRIBUTING.md)
