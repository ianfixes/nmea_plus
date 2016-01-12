require_relative "payload"

module NMEAPlus
  module Message
    module AIS
      # This module contains all the VDM payload types and subtypes.
      # @see {VDMMsg}
      module VDMPayload

        # The base class for the {NMEAPlus::Message::AIS::VDM#ais AIS payload}, which uses its own encoding for its own subtypes
        class VDMMsg < NMEAPlus::Message::AIS::VDMPayload::Payload

          payload_reader :message_type, 0, 6, :_u
          payload_reader :repeat_indicator, 6, 2, :_u
          payload_reader :source_mmsi, 8, 30, :_u

          # The MMSI category as defined by ITU-R M.585-7
          # @!parse attr_reader :mmsi_category
          # @return [Symbol] The symbol for the MMSI category
          def mmsi_category
            case source_mmsi.to_s.rjust(9, '0') # formatted as 9 digit string with leading 0s
            when /[2-7]......../ then :individual_ship
            when /00...1.../ then :coast_station
            when /00...2.../ then :harbor_station
            when /00...3.../ then :pilot_station
            when /00...4.../ then :ais_repeater_station
            when /00......./ then :coast_station
            when /111...1../ then :sar_aircraft_fixed
            when /111...5../ then :sar_aircraft_helicopter
            when /1......../ then :sar_aircraft
            when /8......../ then :handheld
            when /98......./ then :auxiliary_craft
            when /970....../ then :sar_transmitter
            when /972....../ then :man_overboard
            when /974....../ then :epirb
            when /99...1.../ then :aton_physical
            when /99...6.../ then :aton_virtual
            when /99......./ then :aton
            else
              :unknown_mmsi_category
            end
          end

          # The MMSI Maritime Identification Digits (MID)
          # @!parse attr_reader :mid
          # @return [Integer] the MID
          def mid
            range = case mmsi_category
                    when :individual_ship then 0..2
                    when :coast_station, :harbor_station, :pilot_station, :ais_repeater_station then 2..4
                    when :sar_aircraft, :sar_aircraft_fixed, :sar_aircraft_helicopter then 3..5
                    when :aton_physical, :aton_virtual, :aton then 2..4
                    when :auxiliary_craft then 2..4
                    when :handheld then 1..3
                    when :sar_transmitter, :man_overboard, :epirb then 3..5
                    end
            return nil if range.nil?
            source_mmsi.to_s.rjust(9, '0')[range].to_i
          end

          # The ISO 3166-1 indicated by the MMSI Maritime Identification Digits (MID)
          # @!parse attr_reader :mid_country
          # @return [Integer] the MID
          def mid_country
            # https://github.com/S73417H/MIDs
            # https://github.com/alexrabarts/iso_country_codes
            # JSON.parse(IO.read("mids.json")).each {|k, v| puts "when #{k} then #{IsoCountryCodes.find(v[1]).numeric.to_i}" }
            case mid
            when 201 then 8
            when 202 then 20
            when 203 then 40
            when 204 then 620
            when 205 then 56
            when 206 then 112
            when 207 then 100
            when 208 then 336
            when 209 then 196
            when 210 then 196
            when 211 then 276
            when 212 then 196
            when 213 then 268
            when 214 then 498
            when 215 then 470
            when 216 then 51
            when 218 then 276
            when 219 then 208
            when 220 then 208
            when 224 then 724
            when 225 then 724
            when 226 then 250
            when 227 then 250
            when 228 then 250
            when 229 then 470
            when 230 then 246
            when 231 then 234
            when 232 then 826
            when 233 then 826
            when 234 then 826
            when 235 then 826
            when 236 then 292
            when 237 then 300
            when 238 then 191
            when 239 then 300
            when 240 then 300
            when 241 then 300
            when 242 then 504
            when 243 then 348
            when 244 then 528
            when 245 then 528
            when 246 then 528
            when 247 then 380
            when 248 then 470
            when 250 then 372
            when 251 then 352
            when 252 then 438
            when 253 then 442
            when 254 then 492
            when 255 then 620
            when 256 then 470
            when 257 then 578
            when 258 then 578
            when 259 then 578
            when 261 then 616
            when 262 then 499
            when 263 then 620
            when 264 then 642
            when 265 then 752
            when 266 then 752
            when 267 then 703
            when 268 then 674
            when 269 then 756
            when 270 then 203
            when 271 then 792
            when 272 then 804
            when 273 then 643
            when 274 then 807
            when 275 then 428
            when 276 then 233
            when 277 then 440
            when 278 then 705
            when 279 then 688
            when 301 then 660
            when 303 then 840
            when 304 then 28
            when 305 then 28
            when 306 then 531
            when 307 then 533
            when 308 then 44
            when 309 then 44
            when 310 then 60
            when 311 then 60
            when 312 then 84
            when 314 then 52
            when 316 then 124
            when 319 then 136
            when 321 then 188
            when 323 then 192
            when 325 then 212
            when 327 then 214
            when 329 then 312
            when 330 then 308
            when 331 then 304
            when 332 then 320
            when 335 then 340
            when 336 then 332
            when 338 then 840
            when 339 then 388
            when 341 then 659
            when 343 then 662
            when 345 then 484
            when 347 then 474
            when 348 then 500
            when 350 then 558
            when 351 then 591
            when 352 then 591
            when 353 then 591
            when 354 then 591
            when 358 then 630
            when 359 then 222
            when 361 then 666
            when 362 then 780
            when 364 then 796
            when 366 then 840
            when 367 then 840
            when 368 then 840
            when 369 then 840
            when 370 then 591
            when 371 then 591
            when 372 then 591
            when 373 then 591
            when 375 then 670
            when 376 then 670
            when 377 then 670
            when 378 then 92
            when 379 then 850
            when 401 then 4
            when 403 then 682
            when 405 then 50
            when 408 then 48
            when 410 then 64
            when 412 then 156
            when 413 then 156
            when 414 then 156
            when 416 then 158
            when 417 then 144
            when 419 then 356
            when 422 then 364
            when 423 then 31
            when 425 then 368
            when 428 then 376
            when 431 then 392
            when 432 then 392
            when 434 then 795
            when 436 then 398
            when 437 then 860
            when 438 then 400
            when 440 then 410
            when 441 then 410
            when 443 then 275
            when 445 then 408
            when 447 then 414
            when 450 then 422
            when 451 then 417
            when 453 then 446
            when 455 then 462
            when 457 then 496
            when 459 then 524
            when 461 then 512
            when 463 then 586
            when 466 then 634
            when 468 then 760
            when 470 then 784
            when 472 then 762
            when 473 then 887
            when 475 then 887
            when 477 then 344
            when 478 then 70
            when 501 then 250
            when 503 then 36
            when 506 then 104
            when 508 then 96
            when 510 then 583
            when 511 then 585
            when 512 then 554
            when 514 then 116
            when 515 then 116
            when 516 then 162
            when 518 then 184
            when 520 then 242
            when 523 then 166
            when 525 then 360
            when 529 then 296
            when 531 then 418
            when 533 then 458
            when 536 then 580
            when 538 then 584
            when 540 then 540
            when 542 then 570
            when 544 then 520
            when 546 then 258
            when 548 then 608
            when 553 then 598
            when 555 then 612
            when 557 then 90
            when 559 then 16
            when 561 then 882
            when 563 then 702
            when 564 then 702
            when 565 then 702
            when 566 then 702
            when 567 then 764
            when 570 then 776
            when 572 then 798
            when 574 then 704
            when 576 then 548
            when 577 then 548
            when 578 then 876
            when 601 then 710
            when 603 then 24
            when 605 then 12
            when 607 then 250
            when 608 then 826
            when 609 then 108
            when 610 then 204
            when 611 then 72
            when 621 then 262
            when 613 then 120
            when 615 then 178
            when 616 then 174
            when 617 then 132
            when 618 then 250
            when 619 then 384
            when 620 then 174
            when 622 then 818
            when 624 then 231
            when 625 then 232
            when 626 then 266
            when 627 then 288
            when 629 then 270
            when 630 then 624
            when 631 then 226
            when 632 then 324
            when 633 then 854
            when 634 then 404
            when 635 then 250
            when 636 then 430
            when 637 then 430
            when 638 then 728
            when 642 then 434
            when 644 then 426
            when 645 then 480
            when 647 then 450
            when 649 then 466
            when 650 then 508
            when 654 then 478
            when 655 then 454
            when 656 then 566
            when 659 then 516
            when 660 then 638
            when 661 then 646
            when 662 then 729
            when 663 then 686
            when 664 then 690
            when 665 then 654
            when 666 then 706
            when 667 then 694
            when 668 then 678
            when 669 then 748
            when 670 then 148
            when 671 then 768
            when 672 then 788
            when 674 then 834
            when 675 then 800
            when 676 then 180
            when 677 then 834
            when 678 then 894
            when 679 then 716
            when 701 then 32
            when 710 then 76
            when 720 then 68
            when 725 then 152
            when 730 then 170
            when 735 then 218
            when 740 then 238
            when 745 then 254
            when 750 then 328
            when 755 then 600
            when 760 then 604
            when 765 then 740
            when 770 then 858
            when 775 then 862
            end
          end

          # The MMSI category as defined by ITU-R M.585-7
          # @!parse attr_reader :mmsi_category_description
          # @return [String] the human-readable description the MMSI category
          def mmsi_category_description
            case mmsi_category
            when :individual_ship then "Individual ship"
            when :coast_station then "Coast station"
            when :harbor_station then "Harbor station"
            when :pilot_station then "Pilot station"
            when :ais_repeater_station then "AIS repeater station"
            when :sar_aircraft then "SAR aircraft"
            when :sar_aircraft_fixed then "SAR fixed-wing aircraft"
            when :sar_aircraft_helicopter then "SAR helicopter"
            when :aton_physical then "Physical AIS AtoN"
            when :aton_virtual then "Virtual AIS AtoN"
            when :aton then "AIS Aid to Navigation"
            when :auxiliary_craft then "Auxiliary craft"
            when :handheld then "Handheld transceiver"
            when :sar_transmitter then "AIS-SART"
            when :man_overboard then "MOB (Man Overboard)"
            when :epirb then "EPIRB"
            else
              mmsi_category.to_s
            end
          end

          # The ship cargo type description lookup table
          # @param code [Integer] The cargo type id
          # @return [String] Cargo type description
          def get_ship_cargo_type_description(code)
            case code
            when 0 then nil
            when 1...19 then "(future use)"
            when 20 then "WIG (any)"
            when 21 then "WIG Hazardous category A"
            when 22 then "WIG Hazardous category B"
            when 23 then "WIG Hazardous category C"
            when 24 then "WIG Hazardous category D"
            when 25...29 then "WIG (future use)"
            when 30 then "Fishing"
            when 31 then "Towing"
            when 32 then "Towing (large)"
            when 33 then "Dredging/underwater ops"
            when 34 then "Diving ops"
            when 35 then "Military ops"
            when 36 then "Sailing"
            when 37 then "Pleasure craft"
            when 38, 39 then "Reserved"
            when 40 then "High Speed Craft"
            when 41 then "HSC Hazardous category A"
            when 42 then "HSC Hazardous category B"
            when 43 then "HSC Hazardous category C"
            when 44 then "HSC Hazardous category D"
            when 45...48 then "HSC (reserved)"
            when 49 then "HSC (no additional information)"
            when 50 then "Pilot Vessel"
            when 51 then "Search and Rescue Vessel"
            when 52 then "Tug"
            when 53 then "Port Tender"
            when 54 then "Anti-pollution equipment"
            when 55 then "Law Enforcement"
            when 56, 57 then "Spare - Local Vessel"
            when 58 then "Medical Transport"
            when 59 then "Noncombatant ship according to RR Resolution No. 18"
            when 60 then "Passenger"
            when 61 then "Passenger, Hazardous category A"
            when 62 then "Passenger, Hazardous category B"
            when 63 then "Passenger, Hazardous category C"
            when 64 then "Passenger, Hazardous category D"
            when 65..68 then "Passenger, Reserved for future use"
            when 69 then "Passenger, No additional information"
            when 70 then "Cargo"
            when 71 then "Cargo, Hazardous category A"
            when 72 then "Cargo, Hazardous category B"
            when 73 then "Cargo, Hazardous category C"
            when 74 then "Cargo, Hazardous category D"
            when 75..78 then "Cargo, Reserved for future use"
            when 79 then "Cargo, No additional information"
            when 80 then "Tanker"
            when 81 then "Tanker, Hazardous category A"
            when 82 then "Tanker, Hazardous category B"
            when 83 then "Tanker, Hazardous category C"
            when 84 then "Tanker, Hazardous category D"
            when 85.88 then "Tanker, Reserved for future use"
            when 89 then "Tanker, No additional information"
            when 90 then "Other Type"
            when 91 then "Other Type, Hazardous category A"
            when 92 then "Other Type, Hazardous category B"
            when 93 then "Other Type, Hazardous category C"
            when 94 then "Other Type, Hazardous category D"
            when 95..98 then "Other Type, Reserved for future use"
            when 99 then "Other Type, no additional information"
            end
          end

          # An MMSI is associated with an auxiliary craft when it is of the form 98XXXYYYY
          def auxiliary_craft?
            980_000_000 < source_mmsi && source_mmsi < 990_000_000
          end

          # @param code [Integer] The navigational status id
          # @return [String] Navigational status description
          def get_navigational_status_description(code)
            return nil if code.nil?
            case code
            when 0 then "Under way using engine"
            when 1 then "At anchor"
            when 2 then "Not under command"
            when 3 then "Restricted manoeuverability"
            when 4 then "Constrained by her draught"
            when 5 then "Moored"
            when 6 then "Aground"
            when 7 then "Engaged in Fishing"
            when 8 then "Under way sailing"
            when 9...13 then "Reserved for future use"
            when 14 then "AIS-SART active"
            else
              "Not defined"
            end
          end

        end

        # We haven't defined all the {NMEAPlus::Message::AIS::VDM#ais AIS payload} types, so this is a catch-all
        class VDMMsgUndefined < VDMMsg; end

      end
    end
  end
end
