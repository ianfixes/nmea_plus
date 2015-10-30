
require_relative "message_factory"
require_relative "message/nmea/gpgga"

module NMEAPlus

  class NMEAMessageFactory < MessageFactory

    def self.parent_module
      "NMEA"
    end

    def self.alternate_data_type(data_type)
      # match last 3 digits (get rid of talker)
      case data_type[2..4]
        when "AAM"; return "GPAAM"
      end
    end
  end

end
