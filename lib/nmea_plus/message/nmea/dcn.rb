require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # DCN - DECCA Position
      class DCN < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :decca_chain_id, 1, :_integer
        field_reader :red_zone_id, 2, :_string
        field_reader :red_position_line, 3, :_float
        field_reader :red_master_line_ok?, 4, :_av_boolean
        field_reader :green_zone_id, 5, :_string
        field_reader :green_position_line, 6, :_float
        field_reader :green_master_line_ok?, 7, :_av_boolean
        field_reader :purple_zone_id, 8, :_string
        field_reader :purple_position_line, 9, :_float
        field_reader :purple_master_line_ok?, 10, :_av_boolean
        field_reader :use_red_line_navigation?, 11, :_av_boolean
        field_reader :use_green_line_navigation?, 12, :_av_boolean
        field_reader :use_purple_line_navigation?, 13, :_av_boolean
        field_reader :position_uncertainty, 14, :_float
        field_reader :position_uncertainty_units, 15, :_string
        field_reader :fix_data_basis, 16, :_integer

        # @!parse attr_reader :fix_data_basis_description
        # @return [String]
        def fix_data_basis_description
          case fix_data_basis
          when 1 then return "Normal pattern"
          when 2 then return "Lane identification pattern"
          when 3 then return "Lane identification transmissions"
          end
          nil
        end
      end
    end
  end
end
