require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class RMC < NMEAPlus::Message::NMEA::NMEAMessage

        def utc_time
          # get / check fields
          t_field = @fields[1]
          d_field = @fields[9]
          return nil if t_field.nil? or t_field.empty?
          return nil if d_field.nil? or d_field.empty?

          # get formats and time
          time_format = /(\d{2})(\d{2})(\d{2}(\.\d+)?)/
          date_format = /(\d{2})(\d{2})(\d{2})/
          now = Time.now

          # crunch numbers
          begin
            dmy = date_format.match(d_field)
            hms = time_format.match(t_field)
            Time.new(2000 + dmy[3].to_i, dmy[2].to_i, dmy[1].to_i, hms[1].to_i, hms[2].to_i, hms[3].to_f)
          rescue
            nil
          end
        end

        field_reader :active?, 2, :_av_boolean

        def latitude
          _degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        def longitude
          _degrees_minutes_to_decimal(@fields[5], @fields[6])
        end

        field_reader :speed_over_ground_knots, 7, :_float
        field_reader :track_made_good_degrees_true, 8, :_float

        def magnetic_variation_degrees
          _nsew_signed_float(@fields[10], @fields[11])
        end

        field_reader :faa_mode, 12, :_string
      end
    end
  end
end
