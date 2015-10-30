
require_relative "message_factory"
require_relative "message/nmea/gpgga"

module NMEAPlus

  class NMEAMessageFactory < MessageFactory

    def self.parent_module
      "NMEA"
    end
  end

end
