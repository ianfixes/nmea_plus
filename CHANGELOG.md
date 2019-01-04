# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
* Support for AIS message 17
* More standards (AIS specs)
* Issue-creation script for AIS 6 and 8 binary subtypes

### Changed
* CI tests now run on Ruby 2.2 - 2.6, due to bundler being end-of-lifed

### Deprecated

### Removed

### Fixed

### Security

## [1.0.22] - 2018-05-07

### Added
* Documentation and badge

### Security
* Bumped `yard` and `rubocop` versions as per GitHub recommendations


## [1.0.21]
### Changed
* Author


## [1.0.20] - 2016-10-03

### Added
* Support for non-approved sentences
* `BEC`, `BER`, `BPI`
* `DECCA` description
* `DRU`
* `GDA`, `GLA`, `GOA`, `GDF`, `GDP`, `GLF`, `GLP`, `GXF`, `GXP`
* `HCC`, `HCD`, `HTC`, `HVD`, `HVM`
* `IMA`
* `MDA`, `MHU`, `MMB`, `MTA`, `MWH`, `MWS`
* `OLW`, `OMP`, `OMP`, `ONZ`
* `RNN`
* `SBK`, `SCY`, `SCD`, `SDB`, `SGD`, `SGR`, `SIU`, `SNC`, `SNU`, `SPS`, `SSF`, `STC`, `STR`, `SYS`
* `TEC`, `TEP`, `TGA`, `TIF`, `TRP`, `TRS`
* `VCD`, `VPE`, `VTA`, `VTI`, `VWE`, `VWR`, `VWT`
* `WDC`, `WDR`, `WFM`, `WNR`
* `YWP`, `YWS`
* `ZFI`, `ZPI`, `ZTA`, `ZTE`, `ZTI`, `ZWP`, `ZCD`, `ZZU`, `ZEV`, `ZLZ`

### Changed
* Formal class for `AIVDO`
* only `GXA` has satellite field
* Proprietary NMEA messages use their own directory
* Fixed `OLN` data types
* Fixed `MWS` fields
* Waypoint IDs are now strings
* `SGR` and `GRI` fixes
* `VTI` field names changed
* `YWP` fields changed


## [1.0.19] - 2017-01-09
* Documentation and static analysis fixes


## [1.0.18] - 2017-01-09
* Added AIVDO support


## [1.0.17] - 2016-10-04
* Added AIS message type 10


## [1.0.16] - 2016-10-04
* Added AIS message type 16


## [1.0.15] - 2016-10-03
* Added AIS message type 15


## [1.0.14] - 2016-09-29
* Added AIS message 8 subtype 200/10


## [1.0.13] - 2016-09-22
* Make better assumptions about year in dates/times, and recognize nil


## [1.0.12] - 2016-06-06
* Fixed a bug where UTC times were rooted in the local timezone instead (via @CoolElvis)
* Stopped caching single-part messages as if waiting for their next part to arrive


## [1.0.11] - 2016-02-21
* Handled cases where corrupted multipart AIS messages could cause a crash in payload decoding
* Added country codes for panama, and contributed them upstream
* Made MMSI field its own rich object, as the MMSI number itself contains information
* Added AIS message 6 subtypes 1/0, 1/2, 1/3, 1/4, 1/5
* Added AIS message 8 subtypes 1/0
* Documentation fixes


## [1.0.10] - 2016-01-26
* Documentation fixes
* Add message 8 subtype 1/22


## [1.0.9] - 2016-01-13
* Added MMSI category, and extraction of MID and country codes
* Added test cases for AIS message type 1, 2, 3, 4, 5, 9
* Added AIS message 6 subtype 235/10
* Fixed rate of turn calculation in AIS message type 3
* Fixed DTE polarity
* Added AIS messages 5, 7, 11, 12, 13


## [1.0.8] - 2016-01-05
* Fixed integer decodeing
* Fixed integer conversation for latitude
* Added support to detect nil indications in various fields
* Added AIS message types 14, 27
* Added more tests
* Refactored code for succinctness in binary field specificaitons
* Added some AIS message 8 subtypes
* Added more documentation on NMEA


## [1.0.7] - 2015-12-07
* Added AIS message types 20, 24
* Added more tests


## [1.0.6] - 2015-12-01
* Fixed documentation generation and yard macros
* Fixed nil handling for various fields
* Added AIS message types 4, 5, 9, 12, 14, 19, 29, 21

[Unreleased]: https://github.com/ianfixes/nmea_plus/compare/v1.0.22...HEAD
[1.0.22]: https://github.com/ianfixes/nmea_plus/compare/v1.0.21...v1.0.22
[1.0.21]: https://github.com/ianfixes/nmea_plus/compare/v1.0.20...v1.0.21
[1.0.20]: https://github.com/ianfixes/nmea_plus/compare/v1.0.19...v1.0.20
[1.0.19]: https://github.com/ianfixes/nmea_plus/compare/v1.0.18...v1.0.19
[1.0.18]: https://github.com/ianfixes/nmea_plus/compare/v1.0.17...v1.0.18
[1.0.17]: https://github.com/ianfixes/nmea_plus/compare/v1.0.16...v1.0.17
[1.0.16]: https://github.com/ianfixes/nmea_plus/compare/v1.0.15...v1.0.16
[1.0.15]: https://github.com/ianfixes/nmea_plus/compare/v1.0.14...v1.0.15
[1.0.14]: https://github.com/ianfixes/nmea_plus/compare/v1.0.13...v1.0.14
[1.0.13]: https://github.com/ianfixes/nmea_plus/compare/v1.0.12...v1.0.13
[1.0.12]: https://github.com/ianfixes/nmea_plus/compare/v1.0.11...v1.0.12
[1.0.11]: https://github.com/ianfixes/nmea_plus/compare/v1.0.10...v1.0.11
[1.0.10]: https://github.com/ianfixes/nmea_plus/compare/v1.0.9...v1.0.10
[1.0.9]: https://github.com/ianfixes/nmea_plus/compare/v1.0.8...v1.0.9
[1.0.8]: https://github.com/ianfixes/nmea_plus/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/ianfixes/nmea_plus/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/ianfixes/nmea_plus/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/ianfixes/nmea_plus/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/ianfixes/nmea_plus/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/ianfixes/nmea_plus/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/ianfixes/nmea_plus/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/ianfixes/nmea_plus/compare/v1.0.0...v1.0.1
