
require_relative "message_factory"
require_relative "message/nmea/gga"
require_relative "message/nmea/aam"
require_relative "message/nmea/alm"
require_relative "message/nmea/apa"
require_relative "message/nmea/apb"
require_relative "message/nmea/bod"


=begin
require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class  < NMEAPlus::Message::NMEA::NMEAMessage

      end
    end
  end
end
=end

module NMEAPlus

  class NMEAMessageFactory < MessageFactory

    def self.parent_module
      "NMEA"
    end

    def self.alternate_data_type(data_type)
      # match last 3 digits (get rid of talker)
      data_type[2..4]
    end
  end

end
