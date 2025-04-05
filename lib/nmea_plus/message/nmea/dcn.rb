require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # DCN - DECCA Position
      #
      # Status and lines-of-position for a specified DECCA chain.
      class DCN < NMEAPlus::Message::NMEA::NMEAMessage
        # DECCA chain identifier
        field_reader :decca_chain_id, 1, :_integer

        # Red zone identifier, number-letter
        field_reader :red_zone_id, 2, :_string

        # Red line of position (LOP)
        field_reader :red_position_line, 3, :_float

        # Status: Red-master line, true = Valid, false = Data not valid
        field_reader :red_master_line_ok?, 4, :_av_boolean

        # Green zone identifier, number-letter
        field_reader :green_zone_id, 5, :_string

        # Green line of position (LOP)
        field_reader :green_position_line, 6, :_float

        # Status: Green-master line, true = Valid, false = Data not valid
        field_reader :green_master_line_ok?, 7, :_av_boolean

        # Purple zone identifier, number-letter
        field_reader :purple_zone_id, 8, :_string

        # Purple line of position (LOP)
        field_reader :purple_position_line, 9, :_float

        # Status: Purple-master line, true = Valid, false = Data not valid
        field_reader :purple_master_line_ok?, 10, :_av_boolean

        # Red-line navigation use
        field_reader :use_red_line_navigation?, 11, :_av_boolean

        # Green-line navigation use
        field_reader :use_green_line_navigation?, 12, :_av_boolean

        # Purple-line navigation use
        field_reader :use_purple_line_navigation?, 13, :_av_boolean

        # Position uncertainty, n. miles
        field_reader :position_uncertainty, 14, :_float
        field_reader :position_uncertainty_units, 15, :_string

        # Fix data basis:
        #
        # 1 = Normal pattern
        # 2 = Lane identification pattern
        # 3 = Lane identification transmissions
        field_reader :fix_data_basis, 16, :_integer

        # Textual description of fix data basis
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
