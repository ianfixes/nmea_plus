require_relative 'vdm_msg8_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 8: Binary Broadcast Message Subtype: Meteorological and Hydrological Data (IMO289)
        class VDMMsg8d1f31 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg8DynamicPayload

          payload_reader :longitude, 56, 25, :_I, 60 * 10**3, 181
          payload_reader :latitude, 81, 24, :_I, 60 * 10**3, 91
          payload_reader :position_10m_accuracy?, 105, 1, :_b

          # @!parse attr_reader :current_time
          # @return [Time] current time, assumed to be in UTC
          def current_time
            now = Time.now
            day = _u(106, 5)
            hour = _u(111, 5)
            minute = _u(116, 6)
            return nil if 0 == day
            return nil if 24 == hour
            return nil if 60 == minute
            Time.new(now.year, now.month, day, hour, minute, 0, "+00:00")
          end

          payload_reader :wind_speed_average, 122, 7, :_u, 127
          payload_reader :wind_speed_gust, 129, 7, :_u, 127
          payload_reader :wind_direction, 136, 9, :_u, 360
          payload_reader :wind_direction_gust, 145, 9, :_u, 360
          payload_reader :air_temperature, 154, 11, :_I, 10, -1024
          payload_reader :relative_humidity, 165, 7, :_u, 101
          payload_reader :dew_point, 172, 10, :_I, 10, 501
          payload_reader :air_pressure_hpa, 182, 9, :_UU, 1, 799, 511
          payload_reader :air_pressure_tendency, 191, 2, :_u, 3

          # @!parse attr_reader :air_pressure_tendency_description
          # @return [String] pressure tendency description
          def air_pressure_tendency_description
            trend_description(air_pressure_tendency)
          end

          payload_reader :visibility_greater_than, 193, 1, :_b
          payload_reader :horizontal_visibility, 194, 8, :_U, 10, 255
          payload_reader :water_level, 201, 12, :_UU, 10**2, -10, 4001
          payload_reader :water_level_tendency, 213, 2, :_u, 3

          # @!parse attr_reader :water_level_tendency_description
          # @return [String] water level tendency description
          def water_level_tendency_description
            trend_description(water_level_tendency)
          end

          payload_reader :water_current_speed1, 215, 8, :_U, 10, 255
          payload_reader :water_current_direction1, 223, 9, :_u, 360

          # surface water current
          # @!parse attr_reader :water_current_depth1
          # @return [Float] depth of measurement
          def water_current_depth1
            0
          end

          payload_reader :water_current_speed2, 232, 8, :_U, 10, 255
          payload_reader :water_current_direction2, 240, 9, :_u, 360
          payload_reader :water_current_depth2, 249, 5, :_U, 10, 31

          payload_reader :water_current_speed3, 254, 8, :_U, 10, 255
          payload_reader :water_current_direction3, 262, 9, :_u, 360
          payload_reader :water_current_depth3, 271, 5, :_U, 10, 31

          payload_reader :wave_height, 276, 8, :_U, 10, 255
          payload_reader :wave_period, 284, 6, :_u, 63
          payload_reader :wave_direction, 290, 9, :_u, 360
          payload_reader :swell_height, 299, 8, :_U, 10, 255
          payload_reader :swell_period, 307, 6, :_u, 63
          payload_reader :swell_direction, 313, 9, :_u, 360
          payload_reader :sea_state_beaufort, 322, 4, :_e

          payload_reader :water_temperature, 326, 10, :_I, 1, 501
          payload_reader :precipitation_type, 336, 3, :_u, 7

          # precipitation type description
          # @param [Integer] code The code for precipitation
          # @return [String] the description
          def precipitation_description
            case precipitation_type
            when 0 then return "Reserved"
            when 1 then return "Rain"
            when 2 then return "Thunderstorm"
            when 3 then return "Freezing rain"
            when 4 then return "Mixed/ice"
            when 5 then return "Snow"
            when 6 then return "Reserved"
              # 7 is nil
            end
          end

          # @!parse attr_reader :salinity
          # @return [Float] salinity
          def salinity
            ret = _U(339, 9, 10)
            return nil if ret > 51.0 # 51.1 for sensor not available, otherwise n/a
          end

          # @!parse attr_reader :salinity_sensor_unavailable?
          # @return [bool]
          def salinity_sensor_unavailable?
            _u(339, 9) == 511
          end

          payload_reader :ice_code, 348, 2, :_u, 3

          # @param [Integer] code The code for ice
          # @return [String] the description
          def ice_description
            case ice_code
            when 0 then return "No"
            when 1 then return "Yes"
            when 2 then return "(reserved)"
            end
          end

          # trend description
          # @param [Integer] code The trend code
          # @return [String] the description
          def trend_description(code)
            case code
            when 0 then return "steady"
            when 1 then return "decreasing"
            when 2 then return "increasing"
            end
          end

        end
      end
    end
  end
end
