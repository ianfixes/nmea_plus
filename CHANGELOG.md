
### Version 1.0.12

* Fixed a bug where UTC times were rooted in the local timezone instead (via @CoolElvis)
* Stopped caching single-part messages as if waiting for their next part to arrive


### Version 1.0.11

* Handled cases where corrupted multipart AIS messages could cause a crash in payload decoding
* Added country codes for panama, and contributed them upstream
* Made MMSI field its own rich object, as the MMSI number itself contains information
* Added AIS message 6 subtypes 1/0, 1/2, 1/3, 1/4, 1/5
* Added AIS message 8 subtypes 1/0
* Documentation fixes


### Version 1.0.10

* Documentation fixes
* Add message 8 subtype 1/22


### Version 1.0.9

* Added MMSI category, and extraction of MID and country codes
* Added test cases for AIS message type 1, 2, 3, 4, 5, 9
* Added AIS message 6 subtype 235/10
* Fixed rate of turn calculation in AIS message type 3
* Fixed DTE polarity
* Added AIS messages 5, 7, 11, 12, 13


### Version 1.0.8

* Fixed integer decodeing
* Fixed integer conversation for latitude
* Added support to detect nil indications in various fields
* Added AIS message types 14, 27
* Added more tests
* Refactored code for succinctness in binary field specificaitons
* Added some AIS message 8 subtypes
* Added more documentation on NMEA


### Version 1.0.7

* Added AIS message types 20, 24
* Added more tests


### Version 1.0.6

* Fixed documentation generation and yard macros
* Fixed nil handling for various fields
* Added AIS message types 4, 5, 9, 12, 14, 19, 29, 21
