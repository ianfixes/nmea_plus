require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SLC - Loran-C Status
      class SLC < NMEAPlus::Message::NMEA::NMEAMessage

        # container for Omega lane indicators
        class SLCStationReport
          # Used in lat/lon calculation
          # @return [Boolean]
          attr_reader :used_in_calculation

          # Status: Blink Warning Flag
          # @return [Boolean]
          attr_reader :blink_warning

          # Status: Cycle Lock Warning Flag
          # @return [Boolean]
          attr_reader :cycle_lock_warning

          # Status: SNR Warning Flag
          # @return [Boolean]
          attr_reader :snr_warning

          # SNR value, 000 to 999
          # @return [Integer]
          attr_reader :snr

          # @param arr [Array<String, Integer>] a string and 2 integers
          # @param is_master [Boolean] Whether this station is the master
          def initialize(arr, is_master)
            @arr = arr
            @used_in_calculation  = is_master ? true : NMEA::NMEAMessage._av_boolean(arr[0])
            @blink_warning        = NMEA::NMEAMessage._av_boolean(arr[1])
            @cycle_lock_warning   = NMEA::NMEAMessage._av_boolean(arr[2])
            @snr_warning          = NMEA::NMEAMessage._av_boolean(arr[3])
            @snr                  = arr[4].to_i
          end
        end

        # station Status
        # @!parse attr_reader :master_station
        # @return [SLCStationReport]
        def master_station
          SLCStationReport.new(@fields[0..4], true)
        end

        # Station statuses.  Master station at index 0, all secondary stations at their index number
        # @!parse attr_reader :stations
        # @return [Array<SLCStationReport>]
        def stations
          [
            master_station,
            SLCStationReport.new(@fields[5..9], false),
            SLCStationReport.new(@fields[10..14], false),
            SLCStationReport.new(@fields[15..19], false),
            SLCStationReport.new(@fields[20..24], false),
            SLCStationReport.new(@fields[25..29], false),
          ]
        end

      end
    end
  end
end
